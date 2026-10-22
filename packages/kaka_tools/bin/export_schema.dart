import 'dart:convert';
import 'dart:io';

import 'package:kaka_tools/kaka_tools.dart';

/// Regenerates `schema/tools.v1.json` from the Dart catalog.
void main() {
  final json = const JsonEncoder.withIndent('  ').convert({
    'tools_version': toolsVersion,
    'tools': [for (final t in kakaTools) t.toMcp()],
  });
  File('schema/tools.v1.json').writeAsStringSync('$json\n');
}
