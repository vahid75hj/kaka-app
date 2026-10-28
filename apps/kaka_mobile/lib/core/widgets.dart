import 'package:flutter/material.dart';

import '../theme/kaka_colors.dart';

/// A bordered card from the design system.
class KCard extends StatelessWidget {
  const KCard({super.key, required this.child, this.padding = const EdgeInsets.all(16), this.onTap});
  final Widget child;
  final EdgeInsets padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => Card(
    clipBehavior: Clip.antiAlias,
    child: InkWell(
      onTap: onTap,
      child: Padding(padding: padding, child: child),
    ),
  );
}

class SectionHeader extends StatelessWidget {
  const SectionHeader(this.title, {super.key, this.action, this.onAction});
  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final c = KakaColors.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 22, 0, 10),
      child: Row(
        children: [
          Expanded(
            child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
          ),
          if (action != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                action!,
                style: TextStyle(fontSize: 13, color: c.accentText, fontWeight: FontWeight.w600),
              ),
            ),
        ],
      ),
    );
  }
}

/// Amounts are always laid out LTR-safe so "-1,234" never flips in RTL.
class AmountText extends StatelessWidget {
  const AmountText(this.text, {super.key, this.style, this.color});
  final String text;
  final TextStyle? style;
  final Color? color;

  @override
  Widget build(BuildContext context) => Text(
    text,
    textDirection: Directionality.of(context),
    style: (style ?? const TextStyle()).copyWith(
      color: color,
      fontWeight: style?.fontWeight ?? FontWeight.w800,
      fontFeatures: const [FontFeature.tabularFigures()],
    ),
  );
}

/// Icon + message + optional action for screens with nothing to show yet.
class EmptyState extends StatelessWidget {
  const EmptyState({super.key, required this.icon, required this.message, this.action, this.onAction, this.secondary});
  final IconData icon;
  final String message;
  final String? action;
  final VoidCallback? onAction;

  /// Extra button (e.g. "Paste SMS") under the main action.
  final Widget? secondary;

  @override
  Widget build(BuildContext context) {
    final c = KakaColors.of(context);
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(color: c.accentSoft, shape: BoxShape.circle),
              child: Icon(icon, size: 30, color: c.accentText),
            ),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: c.textMuted, height: 1.7),
            ),
            if (action != null) ...[
              const SizedBox(height: 16),
              FilledButton.tonal(onPressed: onAction, child: Text(action!)),
            ],
            ?secondary,
          ],
        ),
      ),
    );
  }
}
