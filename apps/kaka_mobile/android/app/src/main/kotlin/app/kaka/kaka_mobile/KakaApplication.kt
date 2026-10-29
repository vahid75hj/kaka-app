package app.kaka.kaka_mobile

import android.app.Application
import android.os.Build
import java.io.File

/**
 * Records any uncaught JVM crash to `last_crash.txt` so the next launch can
 * show it (see [CrashActivity]) instead of the app just closing.
 */
class KakaApplication : Application() {
    override fun onCreate() {
        super.onCreate()
        val previous = Thread.getDefaultUncaughtExceptionHandler()
        Thread.setDefaultUncaughtExceptionHandler { thread, e ->
            try {
                val info = try {
                    packageManager.getPackageInfo(packageName, 0).versionName
                } catch (_: Throwable) {
                    "?"
                }
                crashFile(this).writeText(
                    "Kaka $info · Android ${Build.VERSION.RELEASE} (SDK ${Build.VERSION.SDK_INT}) · " +
                        "${Build.MANUFACTURER} ${Build.MODEL}\nthread: ${thread.name}\n\n${e.stackTraceToString()}",
                )
            } catch (_: Throwable) {
            }
            previous?.uncaughtException(thread, e)
        }
    }

    companion object {
        fun crashFile(ctx: android.content.Context) = File(ctx.noBackupFilesDir, "last_crash.txt")
    }
}
