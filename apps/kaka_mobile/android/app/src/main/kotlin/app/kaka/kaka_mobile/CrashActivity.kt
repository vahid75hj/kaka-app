package app.kaka.kaka_mobile

import android.app.Activity
import android.content.ClipData
import android.content.ClipboardManager
import android.content.Intent
import android.os.Bundle
import android.view.ViewGroup
import android.widget.Button
import android.widget.LinearLayout
import android.widget.ScrollView
import android.widget.TextView
import android.widget.Toast

/** Plain (non-Flutter) screen with the previous crash, copyable. */
class CrashActivity : Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        val file = KakaApplication.crashFile(this)
        val text = try { file.readText() } catch (_: Throwable) { "(no crash log)" }
        val pad = (16 * resources.displayMetrics.density).toInt()
        val root = LinearLayout(this).apply { orientation = LinearLayout.VERTICAL; setPadding(pad, pad * 2, pad, pad) }
        root.addView(TextView(this).apply {
            textSize = 18f
            this.text = "کاکا دفعه‌ی قبل بسته شد — متن خطا را کپی کن و بفرست.\nKaka crashed last time — copy this and send it."
        })
        val body = TextView(this).apply { setTextIsSelectable(true); textSize = 11f; this.text = text; typeface = android.graphics.Typeface.MONOSPACE }
        root.addView(ScrollView(this).apply { addView(body) }, LinearLayout.LayoutParams(ViewGroup.LayoutParams.MATCH_PARENT, 0, 1f))
        root.addView(Button(this).apply {
            this.text = "کپی خطا / Copy error"
            setOnClickListener {
                getSystemService(ClipboardManager::class.java).setPrimaryClip(ClipData.newPlainText("Kaka crash", text))
                Toast.makeText(this@CrashActivity, "Copied", Toast.LENGTH_SHORT).show()
            }
        })
        root.addView(Button(this).apply {
            this.text = "دوباره باز کن / Open Kaka again"
            setOnClickListener {
                file.delete()
                startActivity(Intent(this@CrashActivity, MainActivity::class.java).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK))
                finish()
            }
        })
        setContentView(root)
    }
}
