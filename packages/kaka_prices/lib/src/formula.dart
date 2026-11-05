/// Tiny multiply/divide formula evaluator with cycle detection.
///
/// Tokens are binding ids or catalog symbols already resolved to numbers by the
/// caller. Expression example: `btc_usdt * usdt_usd`.
///
/// Returns null when the expression is empty. Throws [FormatException] on
/// syntax errors or cycles.
double? evalFormula(
  String expr,
  double Function(String name) lookup, {
  Set<String>? stack,
}) {
  final s = expr.trim();
  if (s.isEmpty) return null;
  // TODO(v0.8+): wire formula bindings in UI; evaluator is ready for * and /.
  final seeing = {...?stack};
  final tokens = _tokenize(s);
  if (tokens.isEmpty) throw const FormatException('empty formula');

  double readOperand(String tok) {
    if (RegExp(r'^\d+(\.\d+)?$').hasMatch(tok)) return double.parse(tok);
    if (seeing.contains(tok)) throw FormatException('cycle in formula: $tok');
    seeing.add(tok);
    try {
      return lookup(tok);
    } finally {
      seeing.remove(tok);
    }
  }

  var value = readOperand(tokens.first);
  for (var i = 1; i + 1 < tokens.length; i += 2) {
    final op = tokens[i];
    final rhs = readOperand(tokens[i + 1]);
    if (op == '*') {
      value *= rhs;
    } else if (op == '/') {
      if (rhs == 0) throw const FormatException('division by zero');
      value /= rhs;
    } else {
      throw FormatException('only * and / allowed, got $op');
    }
  }
  if (tokens.length % 2 == 0) throw const FormatException('dangling operator');
  return value;
}

List<String> _tokenize(String s) {
  final out = <String>[];
  final re = RegExp(r'\s*([A-Za-z_][\w\-]*|\d+(?:\.\d+)?|\*|/)\s*');
  var i = 0;
  while (i < s.length) {
    final m = re.matchAsPrefix(s, i);
    if (m == null) throw FormatException('bad formula near: ${s.substring(i)}');
    out.add(m.group(1)!);
    i = m.end;
  }
  return out;
}
