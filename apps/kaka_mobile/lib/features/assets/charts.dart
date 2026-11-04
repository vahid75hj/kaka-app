import 'dart:math' as math;

import 'package:flutter/material.dart';

const chartPalette = [
  Color(0xFFE0A100),
  Color(0xFF3E7BFA),
  Color(0xFF2EAD6B),
  Color(0xFFE5533D),
  Color(0xFF8B5CF6),
  Color(0xFF14B8A6),
  Color(0xFFF97316),
  Color(0xFF64748B),
];

/// Ring chart; labels and percentages are shown in a legend next to it.
class DonutChart extends StatelessWidget {
  const DonutChart({super.key, required this.values, this.size = 120});
  final List<int> values;
  final double size;

  @override
  Widget build(BuildContext context) => SizedBox.square(
    dimension: size,
    child: CustomPaint(painter: _DonutPainter(values, Theme.of(context).colorScheme.surfaceContainerHighest)),
  );
}

class _DonutPainter extends CustomPainter {
  _DonutPainter(this.values, this.empty);
  final List<int> values;
  final Color empty;

  @override
  void paint(Canvas canvas, Size size) {
    final total = values.fold<int>(0, (s, v) => s + math.max(v, 0));
    final stroke = size.width * 0.18;
    final rect = Offset(stroke / 2, stroke / 2) & Size(size.width - stroke, size.height - stroke);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = stroke;
    if (total == 0) {
      canvas.drawArc(rect, 0, math.pi * 2, false, paint..color = empty);
      return;
    }
    var start = -math.pi / 2;
    for (var i = 0; i < values.length; i++) {
      if (values[i] <= 0) continue;
      final sweep = values[i] / total * math.pi * 2;
      canvas.drawArc(rect, start, sweep, false, paint..color = chartPalette[i % chartPalette.length]);
      start += sweep;
    }
  }

  @override
  bool shouldRepaint(_DonutPainter old) => old.values != values;
}

/// Two lines over time (e.g. net worth and assets value), drawn left-to-right
/// regardless of text direction so time reads the same way in RTL.
class TwoLineChart extends StatelessWidget {
  const TwoLineChart({super.key, required this.points, this.height = 140});

  /// (time, first series, second series)
  final List<(DateTime, int, int)> points;
  final double height;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: height,
    width: double.infinity,
    child: CustomPaint(painter: _LinePainter(points, Theme.of(context).dividerColor)),
  );
}

class _LinePainter extends CustomPainter {
  _LinePainter(this.points, this.grid);
  final List<(DateTime, int, int)> points;
  final Color grid;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawLine(Offset(0, size.height - 1), Offset(size.width, size.height - 1), Paint()..color = grid);
    if (points.length < 2) return;
    final t0 = points.first.$1.millisecondsSinceEpoch.toDouble();
    final t1 = points.last.$1.millisecondsSinceEpoch.toDouble();
    final all = [
      for (final p in points) ...[p.$2, p.$3],
    ];
    final lo = all.reduce(math.min).toDouble(), hi = all.reduce(math.max).toDouble();
    final span = hi - lo == 0 ? 1.0 : hi - lo;
    Offset at(DateTime t, int v) => Offset(
      t1 == t0 ? 0 : (t.millisecondsSinceEpoch - t0) / (t1 - t0) * size.width,
      size.height - 4 - (v - lo) / span * (size.height - 8),
    );
    for (final (series, color) in [(1, chartPalette[1]), (2, chartPalette[0])]) {
      final path = Path();
      for (var i = 0; i < points.length; i++) {
        final p = points[i];
        final o = at(p.$1, series == 1 ? p.$2 : p.$3);
        i == 0 ? path.moveTo(o.dx, o.dy) : path.lineTo(o.dx, o.dy);
      }
      canvas.drawPath(
        path,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2.5
          ..color = color,
      );
    }
  }

  @override
  bool shouldRepaint(_LinePainter old) => old.points != points;
}
