package app.kaka.kaka_mobile

import android.content.Intent
import android.view.WindowManager
import io.flutter.embedding.android.FlutterFragmentActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

/**
 * FragmentActivity is required by local_auth (biometric prompt).
 * Text shared to Kaka (ACTION_SEND) or selected text (ACTION_PROCESS_TEXT)
 * is handed to Dart over `app.kaka/share`; Dart turns it into a draft.
 */
class MainActivity : FlutterFragmentActivity() {
    private var channel: MethodChannel? = null
    private var pending: String? = null
    private var sms: SmsBridge? = null

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        sms = SmsBridge(this, flutterEngine.dartExecutor.binaryMessenger)
        // FLAG_SECURE toggle: hides Kaka from screenshots, recordings and the recent-apps preview.
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "app.kaka/window").setMethodCallHandler { call, result ->
            if (call.method == "setSecure") {
                if (call.arguments == true) {
                    window.addFlags(WindowManager.LayoutParams.FLAG_SECURE)
                } else {
                    window.clearFlags(WindowManager.LayoutParams.FLAG_SECURE)
                }
                result.success(null)
            } else {
                result.notImplemented()
            }
        }
        pending = extractText(intent)
        channel = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "app.kaka/share").apply {
            setMethodCallHandler { call, result ->
                if (call.method == "takeSharedText") {
                    result.success(pending)
                    pending = null
                } else {
                    result.notImplemented()
                }
            }
        }
    }

    override fun onRequestPermissionsResult(requestCode: Int, permissions: Array<out String>, grantResults: IntArray) {
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
        sms?.onPermissionResult(requestCode)
    }

    override fun onDestroy() {
        sms?.stopListening()
        super.onDestroy()
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        setIntent(intent)
        extractText(intent)?.let { channel?.invokeMethod("sharedText", it) }
    }

    private fun extractText(intent: Intent?): String? {
        if (intent == null) return null
        val text = when (intent.action) {
            Intent.ACTION_SEND -> intent.getCharSequenceExtra(Intent.EXTRA_TEXT)
            Intent.ACTION_PROCESS_TEXT -> intent.getCharSequenceExtra(Intent.EXTRA_PROCESS_TEXT)
            else -> null
        }
        return text?.toString()?.takeIf { it.isNotBlank() }
    }
}
