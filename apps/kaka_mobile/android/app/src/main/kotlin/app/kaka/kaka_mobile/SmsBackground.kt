package app.kaka.kaka_mobile

import android.Manifest
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.ComponentName
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.os.Build
import android.os.Handler
import android.os.Looper
import android.provider.Telephony
import androidx.core.app.NotificationCompat
import androidx.core.app.NotificationManagerCompat
import androidx.core.content.ContextCompat
import androidx.work.ExistingWorkPolicy
import androidx.work.OneTimeWorkRequestBuilder
import androidx.work.WorkManager
import androidx.work.Worker
import androidx.work.WorkerParameters
import io.flutter.FlutterInjector
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor
import io.flutter.plugin.common.MethodChannel
import org.json.JSONArray
import org.json.JSONObject
import java.io.File
import java.util.concurrent.CountDownLatch
import java.util.concurrent.TimeUnit

/**
 * SMS that arrived while Kaka was closed, waiting for Dart to turn them into drafts.
 * App-private and short-lived: entries are removed once Dart acknowledges them.
 */
object PendingSms {
    private const val MAX = 200
    private const val KEY_ALIAS = "kaka_pending_sms"
    private fun legacyFile(ctx: Context) = File(ctx.filesDir, "sms_pending.json")
    private fun file(ctx: Context) = File(ctx.noBackupFilesDir, "sms_pending.bin")

    @Synchronized
    fun add(ctx: Context, items: List<Map<String, Any>>) {
        val arr = read(ctx)
        for (m in items) arr.put(JSONObject(m))
        // Keep the newest MAX; the inbox scan on next open covers anything older.
        while (arr.length() > MAX) arr.remove(0)
        write(ctx, arr)
    }

    @Synchronized
    fun peek(ctx: Context): List<Map<String, Any>> {
        val arr = read(ctx)
        return (0 until arr.length()).map { i ->
            val o = arr.getJSONObject(i)
            mapOf("sender" to o.optString("sender"), "body" to o.optString("body"), "date" to o.optLong("date"))
        }
    }

    /** Drops the first [count] entries (the ones Dart has stored). */
    @Synchronized
    fun ack(ctx: Context, count: Int) {
        val arr = read(ctx)
        val rest = JSONArray()
        for (i in count until arr.length()) rest.put(arr.get(i))
        if (rest.length() == 0) file(ctx).delete() else write(ctx, rest)
    }

    /** AES-256-GCM with a non-exportable Android Keystore key; file = 12-byte IV + ciphertext. */
    private fun key(): javax.crypto.SecretKey {
        val ks = java.security.KeyStore.getInstance("AndroidKeyStore").apply { load(null) }
        (ks.getKey(KEY_ALIAS, null) as? javax.crypto.SecretKey)?.let { return it }
        val gen = javax.crypto.KeyGenerator.getInstance(android.security.keystore.KeyProperties.KEY_ALGORITHM_AES, "AndroidKeyStore")
        gen.init(
            android.security.keystore.KeyGenParameterSpec.Builder(
                KEY_ALIAS,
                android.security.keystore.KeyProperties.PURPOSE_ENCRYPT or android.security.keystore.KeyProperties.PURPOSE_DECRYPT,
            )
                .setBlockModes(android.security.keystore.KeyProperties.BLOCK_MODE_GCM)
                .setEncryptionPaddings(android.security.keystore.KeyProperties.ENCRYPTION_PADDING_NONE)
                .setKeySize(256)
                .build(),
        )
        return gen.generateKey()
    }

    private fun write(ctx: Context, arr: JSONArray) {
        val c = javax.crypto.Cipher.getInstance("AES/GCM/NoPadding")
        c.init(javax.crypto.Cipher.ENCRYPT_MODE, key())
        val out = c.iv + c.doFinal(arr.toString().toByteArray(Charsets.UTF_8))
        val tmp = File(file(ctx).path + ".tmp")
        tmp.writeBytes(out)
        tmp.renameTo(file(ctx))
    }

    private fun read(ctx: Context): JSONArray {
        val result = try {
            val f = file(ctx)
            if (!f.exists()) {
                JSONArray()
            } else {
                val bytes = f.readBytes()
                val c = javax.crypto.Cipher.getInstance("AES/GCM/NoPadding")
                c.init(javax.crypto.Cipher.DECRYPT_MODE, key(), javax.crypto.spec.GCMParameterSpec(128, bytes, 0, 12))
                JSONArray(String(c.doFinal(bytes, 12, bytes.size - 12), Charsets.UTF_8))
            }
        } catch (_: Exception) {
            // Unreadable (key lost after a restore, tampering): drop it; the inbox scan recovers.
            file(ctx).delete()
            JSONArray()
        }
        // 0.5.0 stored this as plain JSON: fold it in once and delete it.
        val legacy = legacyFile(ctx)
        if (legacy.exists()) {
            try {
                val old = JSONArray(legacy.readText())
                for (i in 0 until old.length()) result.put(old.get(i))
            } catch (_: Exception) {
            }
            legacy.delete()
            try {
                if (result.length() > 0) write(ctx, result)
            } catch (_: Exception) {
            }
        }
        return result
    }
}

/**
 * Manifest receiver, **disabled by default**. It is enabled only while the user has
 * turned on "read bank SMS" *and* "also when Kaka is closed" (see [SmsBackground.setEnabled]).
 * While the app's own live receiver runs, this one does nothing.
 */
class SmsReceiver : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        if (intent.action != Telephony.Sms.Intents.SMS_RECEIVED_ACTION) return
        if (SmsBridge.liveActive) return
        val parts = Telephony.Sms.Intents.getMessagesFromIntent(intent) ?: return
        val items = parts.groupBy { it.originatingAddress ?: "" }.map { (sender, msgs) ->
            mapOf<String, Any>(
                "sender" to sender,
                "body" to msgs.joinToString("") { it.messageBody ?: "" },
                "date" to (msgs.firstOrNull()?.timestampMillis ?: System.currentTimeMillis()),
            )
        }
        if (items.isEmpty()) return
        try {
            PendingSms.add(context, items)
            SmsBackground.schedule(context)
        } catch (e: Throwable) {
            android.util.Log.e("Kaka", "background SMS store failed", e)
        }
    }
}

/** Runs the Dart entry point `smsBackgroundMain` headless to ingest pending SMS. */
class SmsWorker(ctx: Context, params: WorkerParameters) : Worker(ctx, params) {
    override fun doWork(): Result {
        if (PendingSms.peek(applicationContext).isEmpty()) return Result.success()
        val done = CountDownLatch(1)
        val main = Handler(Looper.getMainLooper())
        var engine: FlutterEngine? = null
        main.post {
            try {
                val loader = FlutterInjector.instance().flutterLoader()
                loader.startInitialization(applicationContext)
                loader.ensureInitializationComplete(applicationContext, null)
                val e = FlutterEngine(applicationContext)
                engine = e
                MethodChannel(e.dartExecutor.binaryMessenger, SmsBackground.CHANNEL).setMethodCallHandler { call, result ->
                    when (call.method) {
                        "takePending" -> result.success(PendingSms.peek(applicationContext))
                        "done" -> {
                            val count = call.argument<Int>("ack") ?: 0
                            PendingSms.ack(applicationContext, count)
                            val title = call.argument<String>("title")
                            val body = call.argument<String>("body")
                            if (title != null && body != null) SmsBackground.notify(applicationContext, title, body)
                            result.success(null)
                            done.countDown()
                        }
                        else -> result.notImplemented()
                    }
                }
                e.dartExecutor.executeDartEntrypoint(
                    DartExecutor.DartEntrypoint(loader.findAppBundlePath(), "smsBackgroundMain"),
                )
            } catch (_: Exception) {
                done.countDown()
            }
        }
        val finished = done.await(90, TimeUnit.SECONDS)
        main.post { engine?.destroy() }
        // Unacknowledged items stay pending: retried later, or picked up when the app opens.
        return if (finished || runAttemptCount >= 3) Result.success() else Result.retry()
    }
}

object SmsBackground {
    const val CHANNEL = "app.kaka/sms_bg"
    private const val NOTIFY_CHANNEL = "kaka_sms"
    private const val WORK = "kaka-sms-ingest"

    fun schedule(ctx: Context) {
        WorkManager.getInstance(ctx).enqueueUniqueWork(
            WORK,
            ExistingWorkPolicy.APPEND_OR_REPLACE,
            OneTimeWorkRequestBuilder<SmsWorker>().build(),
        )
    }

    /** Turns the manifest receiver on/off. Off also drops anything not yet ingested. */
    fun setEnabled(ctx: Context, enabled: Boolean) {
        ctx.packageManager.setComponentEnabledSetting(
            ComponentName(ctx, SmsReceiver::class.java),
            if (enabled) PackageManager.COMPONENT_ENABLED_STATE_ENABLED else PackageManager.COMPONENT_ENABLED_STATE_DISABLED,
            PackageManager.DONT_KILL_APP,
        )
        if (!enabled) PendingSms.ack(ctx, Int.MAX_VALUE)
    }

    fun isEnabled(ctx: Context) = ctx.packageManager.getComponentEnabledSetting(
        ComponentName(ctx, SmsReceiver::class.java),
    ) == PackageManager.COMPONENT_ENABLED_STATE_ENABLED

    fun canNotify(ctx: Context) = Build.VERSION.SDK_INT < 33 ||
        ContextCompat.checkSelfPermission(ctx, Manifest.permission.POST_NOTIFICATIONS) == PackageManager.PERMISSION_GRANTED

    fun notify(ctx: Context, title: String, body: String) {
        if (!canNotify(ctx)) return
        val nm = ctx.getSystemService(NotificationManager::class.java)
        if (Build.VERSION.SDK_INT >= 26 && nm.getNotificationChannel(NOTIFY_CHANNEL) == null) {
            nm.createNotificationChannel(NotificationChannel(NOTIFY_CHANNEL, title, NotificationManager.IMPORTANCE_DEFAULT))
        }
        val open = PendingIntent.getActivity(
            ctx,
            0,
            Intent(ctx, MainActivity::class.java).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TOP)
                .putExtra("open", "queue"),
            PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT,
        )
        val n = NotificationCompat.Builder(ctx, NOTIFY_CHANNEL)
            .setSmallIcon(R.drawable.ic_stat_kaka)
            .setContentTitle(title)
            .setContentText(body)
            // Amounts never appear on the lock screen.
            .setVisibility(NotificationCompat.VISIBILITY_PRIVATE)
            .setContentIntent(open)
            .setAutoCancel(true)
            .build()
        try {
            NotificationManagerCompat.from(ctx).notify(7001, n)
        } catch (_: SecurityException) {
        }
    }
}
