package app.kaka.kaka_mobile

import android.Manifest
import android.app.Activity
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.content.pm.PackageManager
import android.os.Build
import android.provider.Telephony
import androidx.core.app.ActivityCompat
import androidx.core.content.ContextCompat
import io.flutter.plugin.common.BinaryMessenger
import io.flutter.plugin.common.MethodChannel

/**
 * Opt-in bank SMS reading over `app.kaka/sms`. Nothing here runs until Dart
 * asks: the permission is requested only when the user turns the feature on,
 * and the receiver lives only while the feature is on and the app is alive.
 * Missed messages are picked up by the incremental inbox scan on resume.
 */
class SmsBridge(private val activity: Activity, messenger: BinaryMessenger) {
    companion object {
        const val REQUEST_CODE = 4711
        private val PERMISSIONS = arrayOf(Manifest.permission.READ_SMS, Manifest.permission.RECEIVE_SMS)
    }

    private val channel = MethodChannel(messenger, "app.kaka/sms")
    private var pendingPermission: MethodChannel.Result? = null
    private var receiver: BroadcastReceiver? = null

    init {
        channel.setMethodCallHandler { call, result ->
            when (call.method) {
                "hasPermission" -> result.success(hasPermission())
                "requestPermission" -> requestPermission(result)
                "senders" -> runIo(result) { senders(call.argument<Number>("sinceMs")!!.toLong()) }
                "inbox" -> runIo(result) {
                    inbox(call.argument<Number>("sinceMs")!!.toLong(), call.argument<List<String>>("senders"))
                }
                "startListening" -> { startListening(); result.success(hasPermission()) }
                "stopListening" -> { stopListening(); result.success(null) }
                else -> result.notImplemented()
            }
        }
    }

    private fun hasPermission() = PERMISSIONS.all {
        ContextCompat.checkSelfPermission(activity, it) == PackageManager.PERMISSION_GRANTED
    }

    private fun requestPermission(result: MethodChannel.Result) {
        if (hasPermission()) return result.success(true)
        pendingPermission?.success(false)
        pendingPermission = result
        ActivityCompat.requestPermissions(activity, PERMISSIONS, REQUEST_CODE)
    }

    fun onPermissionResult(requestCode: Int) {
        if (requestCode != REQUEST_CODE) return
        pendingPermission?.success(hasPermission())
        pendingPermission = null
    }

    private fun runIo(result: MethodChannel.Result, work: () -> Any) {
        if (!hasPermission()) return result.error("permission", "SMS permission not granted", null)
        Thread {
            try {
                val value = work()
                activity.runOnUiThread { result.success(value) }
            } catch (e: Exception) {
                activity.runOnUiThread { result.error("sms", e.message, null) }
            }
        }.start()
    }

    private fun senders(sinceMs: Long): List<Map<String, Any>> {
        val bySender = LinkedHashMap<String, MutableList<String>>()
        val counts = HashMap<String, Int>()
        activity.contentResolver.query(
            Telephony.Sms.Inbox.CONTENT_URI,
            arrayOf(Telephony.Sms.ADDRESS, Telephony.Sms.BODY),
            "${Telephony.Sms.DATE} > ?", arrayOf(sinceMs.toString()),
            "${Telephony.Sms.DATE} DESC",
        )?.use { c ->
            while (c.moveToNext()) {
                val address = c.getString(0) ?: continue
                val body = c.getString(1) ?: continue
                counts[address] = (counts[address] ?: 0) + 1
                val samples = bySender.getOrPut(address) { mutableListOf() }
                if (samples.size < 5) samples.add(body)
            }
        }
        return bySender.map { (s, samples) -> mapOf("sender" to s, "count" to (counts[s] ?: 0), "samples" to samples) }
    }

    private fun inbox(sinceMs: Long, senders: List<String>?): List<Map<String, Any>> {
        val out = ArrayList<Map<String, Any>>()
        activity.contentResolver.query(
            Telephony.Sms.Inbox.CONTENT_URI,
            arrayOf(Telephony.Sms.ADDRESS, Telephony.Sms.BODY, Telephony.Sms.DATE),
            "${Telephony.Sms.DATE} > ?", arrayOf(sinceMs.toString()),
            "${Telephony.Sms.DATE} ASC",
        )?.use { c ->
            while (c.moveToNext() && out.size < 5000) {
                val address = c.getString(0) ?: continue
                val body = c.getString(1) ?: continue
                // Sender filtering is finalized in Dart (normalized forms); this is a cheap pre-filter.
                if (senders != null && senders.none { address.contains(it, ignoreCase = true) || it.contains(address.takeLast(6)) }) continue
                out.add(mapOf("sender" to address, "body" to body, "date" to c.getLong(2)))
            }
        }
        return out
    }

    private fun startListening() {
        if (receiver != null || !hasPermission()) return
        val r = object : BroadcastReceiver() {
            override fun onReceive(context: Context, intent: Intent) {
                val parts = Telephony.Sms.Intents.getMessagesFromIntent(intent) ?: return
                // Multipart SMS arrive as several PDUs; join them per sender.
                parts.groupBy { it.originatingAddress ?: "" }.forEach { (sender, msgs) ->
                    channel.invokeMethod(
                        "sms",
                        mapOf(
                            "sender" to sender,
                            "body" to msgs.joinToString("") { it.messageBody ?: "" },
                            "date" to (msgs.firstOrNull()?.timestampMillis ?: System.currentTimeMillis()),
                        ),
                    )
                }
            }
        }
        val filter = IntentFilter(Telephony.Sms.Intents.SMS_RECEIVED_ACTION)
        if (Build.VERSION.SDK_INT >= 33) {
            activity.registerReceiver(r, filter, Context.RECEIVER_EXPORTED)
        } else {
            activity.registerReceiver(r, filter)
        }
        receiver = r
    }

    fun stopListening() {
        receiver?.let { runCatching { activity.unregisterReceiver(it) } }
        receiver = null
    }
}
