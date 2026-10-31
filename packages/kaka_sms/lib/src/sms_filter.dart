import 'sms_text.dart';

/// Cheap "is this a bank transaction SMS?" check, mirrored in Kotlin
/// (`SmsFilter.kt`) so the background receiver ignores everything else.
/// Shared fixtures: `test/fixtures/sms_filter.json`.
abstract final class SmsFilter {
  static final _otp = RegExp(
    r'رمز\s*(پویا|یکبار|یک بار|دوم|اول|عبور)|کد\s*(تایید|تأیید|ورود|فعال\s*سازی|امنیتی|یکبار)|one.?time|\botp\b|verification|password|\bcode\b',
    caseSensitive: false,
  );
  static final _ad = RegExp(
    r'لغو\s*\d*|https?:|www\.|\.ir\b|تخفیف|جایزه|قرعه|هدیه|بسته|اینترنت|وام|بگیرید|ثبت\s*نام|دانلود|اپلیکیشن|مهلت|اقساط|بیمه',
    caseSensitive: false,
  );
  static final _amount = RegExp(r'\d{1,3}(,\d{3})+|\d{4,}');
  static final _signed = RegExp(
    r'(\d{1,3}(,\d{3})+|\d{4,})\s*[-+](\s|$)|(^|\s|:)[-+]\s*\d{1,3}(,\d{3})+',
    multiLine: true,
  );
  static final _strong = RegExp(r'مانده|موجودی|واریز|برداشت|انتقال|حساب|کارت');
  static final _bankish = RegExp(r'مانده|موجودی|بانک');

  static bool isOtp(String body) => _otp.hasMatch(SmsText.normalize(body));

  /// Amount plus a ledger word (or a signed amount), and not an OTP or an ad.
  static bool looksLikeTransaction(String body) {
    final t = SmsText.normalize(body);
    if (_otp.hasMatch(t) || _ad.hasMatch(t) || !_amount.hasMatch(t)) return false;
    return _strong.hasMatch(t) || _signed.hasMatch(t);
  }

  /// Background receiver rule: a known bank sender needs [looksLikeTransaction];
  /// an unknown one must also show a balance, a bank name or a signed amount.
  static bool shouldStore(String body, {required bool knownSender}) {
    if (!looksLikeTransaction(body)) return false;
    if (knownSender) return true;
    final t = SmsText.normalize(body);
    return _bankish.hasMatch(t) || _signed.hasMatch(t);
  }
}
