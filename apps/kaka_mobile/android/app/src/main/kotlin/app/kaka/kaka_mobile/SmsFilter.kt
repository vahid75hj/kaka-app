package app.kaka.kaka_mobile

/**
 * Kotlin mirror of `kaka_sms/lib/src/sms_filter.dart`: decides in the
 * background receiver whether an SMS is worth storing and notifying.
 * Both sides are tested against `packages/kaka_sms/test/fixtures/sms_filter.json`.
 */
object SmsFilter {
    private val otp = Regex(
        "رمز\\s*(پویا|یکبار|یک بار|دوم|اول|عبور)|کد\\s*(تایید|تأیید|ورود|فعال\\s*سازی|امنیتی|یکبار)|one.?time|\\botp\\b|verification|password|\\bcode\\b",
        RegexOption.IGNORE_CASE,
    )
    private val ad = Regex(
        "لغو\\s*\\d*|https?:|www\\.|\\.ir\\b|تخفیف|جایزه|قرعه|هدیه|بسته|اینترنت|وام|بگیرید|ثبت\\s*نام|دانلود|اپلیکیشن|مهلت|اقساط|بیمه",
        RegexOption.IGNORE_CASE,
    )
    private val amount = Regex("\\d{1,3}(,\\d{3})+|\\d{4,}")
    private val signed = Regex("(\\d{1,3}(,\\d{3})+|\\d{4,})\\s*[-+](\\s|$)|(^|\\s|:)[-+]\\s*\\d{1,3}(,\\d{3})+", RegexOption.MULTILINE)
    private val strong = Regex("مانده|موجودی|واریز|برداشت|انتقال|حساب|کارت")
    private val bankish = Regex("مانده|موجودی|بانک")
    private val invisible = Regex("[\u200b\u200e\u200f\u202a-\u202e\u2066-\u2069\ufeff]")
    private val spaces = Regex("[ \t\u00a0\u200c]+")

    fun digits(s: String): String {
        val b = StringBuilder(s.length)
        for (c in s) b.append(
            when (c) {
                in '\u06f0'..'\u06f9' -> '0' + (c - '\u06f0')
                in '\u0660'..'\u0669' -> '0' + (c - '\u0660')
                else -> c
            },
        )
        return b.toString()
    }

    fun normalize(text: String): String = digits(text)
        .replace('ي', 'ی').replace('ى', 'ی').replace('ك', 'ک').replace('ۀ', 'ه')
        .replace('٬', ',').replace('،', ',').replace("\r", "")
        .replace(invisible, "").replace('*', ' ').replace(spaces, " ")
        .split('\n').map { it.trim() }.filter { it.isNotEmpty() }.joinToString("\n")

    /** Same as Dart `SmsText.sender`. */
    fun sender(s: String): String {
        var d = digits(s).trim().lowercase().replace(Regex("[\\s\\-()]"), "")
        if (Regex("^\\+?\\d+$").matches(d)) {
            d = d.replaceFirst("+", "")
            if (d.startsWith("0098")) d = d.substring(4)
            if (d.startsWith("98") && d.length > 6) d = d.substring(2)
        }
        return d
    }

    fun looksLikeTransaction(body: String): Boolean {
        val t = normalize(body)
        if (otp.containsMatchIn(t) || ad.containsMatchIn(t) || !amount.containsMatchIn(t)) return false
        return strong.containsMatchIn(t) || signed.containsMatchIn(t)
    }

    fun shouldStore(body: String, knownSender: Boolean): Boolean {
        if (!looksLikeTransaction(body)) return false
        if (knownSender) return true
        val t = normalize(body)
        return bankish.containsMatchIn(t) || signed.containsMatchIn(t)
    }
}

/** Senders the user linked (written by Dart via `setKnownSenders`). */
object KnownSenders {
    private const val PREFS = "kaka_sms"
    private const val KEY = "senders"

    fun set(ctx: android.content.Context, senders: List<String>, lang: String) {
        ctx.getSharedPreferences(PREFS, android.content.Context.MODE_PRIVATE).edit()
            .putStringSet(KEY, senders.map { SmsFilter.sender(it) }.toSet()).putString("lang", lang).apply()
    }

    /** The app's language (not the phone's), for the notification text. */
    fun lang(ctx: android.content.Context): String =
        ctx.getSharedPreferences(PREFS, android.content.Context.MODE_PRIVATE).getString("lang", "fa") ?: "fa"

    fun contains(ctx: android.content.Context, sender: String): Boolean =
        ctx.getSharedPreferences(PREFS, android.content.Context.MODE_PRIVATE)
            .getStringSet(KEY, emptySet())!!.contains(SmsFilter.sender(sender))
}
