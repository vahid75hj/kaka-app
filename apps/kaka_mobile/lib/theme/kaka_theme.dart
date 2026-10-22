import 'package:flutter/material.dart';
import 'package:kaka_domain/kaka_domain.dart';

import 'kaka_colors.dart';

abstract final class KakaTheme {
  static ThemeData build(Brightness brightness, Accent accent) {
    final c = KakaColors.resolve(brightness, accent);
    final scheme =
        ColorScheme.fromSeed(
          seedColor: c.accent,
          brightness: brightness,
          dynamicSchemeVariant: accent == Accent.monochrome
              ? DynamicSchemeVariant.monochrome
              : DynamicSchemeVariant.fidelity,
        ).copyWith(
          primary: c.accent,
          onPrimary: c.onAccent,
          surface: c.background,
          onSurface: c.text,
          surfaceContainer: c.card,
          surfaceContainerHighest: c.card,
          outline: c.line,
          outlineVariant: c.line,
          error: c.negative,
        );
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(14),
      side: BorderSide(color: c.line),
    );
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
      fontFamily: 'Vazirmatn',
      scaffoldBackgroundColor: c.background,
      extensions: [c],
      appBarTheme: AppBarTheme(
        backgroundColor: c.background,
        foregroundColor: c.text,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(fontFamily: 'Vazirmatn', fontSize: 20, fontWeight: FontWeight.w800, color: c.text),
      ),
      cardTheme: CardThemeData(color: c.card, elevation: 0, margin: EdgeInsets.zero, shape: shape),
      dividerTheme: DividerThemeData(color: c.line, space: 1),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: c.card,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: c.accent, width: 1.4),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: c.accent,
          foregroundColor: c.onAccent,
          minimumSize: const Size.fromHeight(52),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          textStyle: const TextStyle(fontFamily: 'Vazirmatn', fontSize: 16, fontWeight: FontWeight.w700),
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: c.card,
        indicatorColor: c.accentSoft,
        iconTheme: WidgetStateProperty.resolveWith(
          (s) => IconThemeData(color: s.contains(WidgetState.selected) ? c.accentText : c.textFaint),
        ),
        labelTextStyle: WidgetStateProperty.resolveWith(
          (s) => TextStyle(
            fontFamily: 'Vazirmatn',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: s.contains(WidgetState.selected) ? c.accentText : c.textFaint,
          ),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: c.accent,
        foregroundColor: c.onAccent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: c.card,
        selectedColor: c.accentSoft,
        side: BorderSide(color: c.line),
        labelStyle: TextStyle(fontFamily: 'Vazirmatn', color: c.text),
      ),
      segmentedButtonTheme: SegmentedButtonThemeData(
        style: SegmentedButton.styleFrom(
          selectedBackgroundColor: c.accent,
          selectedForegroundColor: c.onAccent,
          side: BorderSide(color: c.line),
        ),
      ),
    );
  }
}
