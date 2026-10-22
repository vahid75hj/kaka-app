import 'package:flutter/material.dart';
import 'package:kaka_domain/kaka_domain.dart';

/// Kaka's design tokens, mirrored from the ui-v2 mockups.
@immutable
class KakaColors extends ThemeExtension<KakaColors> {
  const KakaColors({
    required this.background,
    required this.card,
    required this.line,
    required this.text,
    required this.textMuted,
    required this.textFaint,
    required this.accent,
    required this.accentText,
    required this.onAccent,
    required this.accentSoft,
    required this.positive,
    required this.negative,
  });

  final Color background;
  final Color card;
  final Color line;
  final Color text;
  final Color textMuted;
  final Color textFaint;
  final Color accent;

  /// Accent used for text/icons (slightly brighter than [accent] on dark).
  final Color accentText;
  final Color onAccent;
  final Color accentSoft;
  final Color positive;
  final Color negative;

  static KakaColors of(BuildContext context) => Theme.of(context).extension<KakaColors>()!;

  factory KakaColors.resolve(Brightness brightness, Accent accent) {
    final dark = brightness == Brightness.dark;
    final base = dark
        ? const KakaColors(
            background: Color(0xFF0E0E0E),
            card: Color(0xFF1A1A1A),
            line: Color(0xFF262626),
            text: Color(0xFFF5F5F5),
            textMuted: Color(0xFF8A8A8A),
            textFaint: Color(0xFF5C5C5C),
            accent: Color(0xFFF5F5F5),
            accentText: Color(0xFFF5F5F5),
            onAccent: Color(0xFF0E0E0E),
            accentSoft: Color(0x0DFFFFFF),
            positive: Color(0xFF6FBF94),
            negative: Color(0xFFE07A72),
          )
        : const KakaColors(
            background: Color(0xFFF7F7F5),
            card: Color(0xFFFFFFFF),
            line: Color(0xFFE7E6E1),
            text: Color(0xFF111111),
            textMuted: Color(0xFF6E6E6A),
            textFaint: Color(0xFFA3A29C),
            accent: Color(0xFF111111),
            accentText: Color(0xFF111111),
            onAccent: Color(0xFFFFFFFF),
            accentSoft: Color(0x0D000000),
            positive: Color(0xFF2F8A5E),
            negative: Color(0xFFC24E47),
          );
    return switch (accent) {
      Accent.monochrome => base,
      Accent.orange => base._withAccent(
        const Color(0xFFE8693D),
        dark ? const Color(0xFFF07D55) : const Color(0xFFC9522A),
        Colors.white,
      ),
      Accent.lime => base._withAccent(
        dark ? const Color(0xFFC8F135) : const Color(0xFF6E8F00),
        dark ? const Color(0xFFC8F135) : const Color(0xFF5A7500),
        dark ? const Color(0xFF111A00) : Colors.white,
      ),
      Accent.blue => base._withAccent(
        const Color(0xFF3D7BFF),
        dark ? const Color(0xFF6E9BFF) : const Color(0xFF2A62E0),
        Colors.white,
      ),
    };
  }

  KakaColors _withAccent(Color a, Color aText, Color on) =>
      copyWith(accent: a, accentText: aText, onAccent: on, accentSoft: a.withValues(alpha: 0.12));

  @override
  KakaColors copyWith({
    Color? background,
    Color? card,
    Color? line,
    Color? text,
    Color? textMuted,
    Color? textFaint,
    Color? accent,
    Color? accentText,
    Color? onAccent,
    Color? accentSoft,
    Color? positive,
    Color? negative,
  }) => KakaColors(
    background: background ?? this.background,
    card: card ?? this.card,
    line: line ?? this.line,
    text: text ?? this.text,
    textMuted: textMuted ?? this.textMuted,
    textFaint: textFaint ?? this.textFaint,
    accent: accent ?? this.accent,
    accentText: accentText ?? this.accentText,
    onAccent: onAccent ?? this.onAccent,
    accentSoft: accentSoft ?? this.accentSoft,
    positive: positive ?? this.positive,
    negative: negative ?? this.negative,
  );

  @override
  KakaColors lerp(KakaColors? other, double t) {
    if (other == null) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return KakaColors(
      background: l(background, other.background),
      card: l(card, other.card),
      line: l(line, other.line),
      text: l(text, other.text),
      textMuted: l(textMuted, other.textMuted),
      textFaint: l(textFaint, other.textFaint),
      accent: l(accent, other.accent),
      accentText: l(accentText, other.accentText),
      onAccent: l(onAccent, other.onAccent),
      accentSoft: l(accentSoft, other.accentSoft),
      positive: l(positive, other.positive),
      negative: l(negative, other.negative),
    );
  }
}
