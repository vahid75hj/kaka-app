
/// Walks a tiny JSONPath subset: `$.a.b`, `$.a['key-1']`, `$.a[0]`, mixed.
Object? jsonPath(Object? root, String path) {
  var p = path.trim();
  if (p.startsWith(r'$')) p = p.substring(1);
  Object? cur = root;
  final re = RegExp(r"""\[['"]([^'"]+)['"]\]|\[(\d+)\]|\.([A-Za-z0-9_\-]+)|([A-Za-z0-9_\-]+)""");
  var matched = false;
  for (final m in re.allMatches(p)) {
    matched = true;
    if (cur == null) return null;
    final quoted = m.group(1);
    final idx = m.group(2);
    final ident = m.group(3) ?? m.group(4);
    if (quoted != null) {
      if (cur is! Map) return null;
      cur = cur[quoted];
    } else if (idx != null) {
      if (cur is! List) return null;
      final i = int.parse(idx);
      if (i < 0 || i >= cur.length) return null;
      cur = cur[i];
    } else if (ident != null) {
      if (cur is! Map) return null;
      cur = cur[ident];
    }
  }
  return matched ? cur : root;
}

/// Reads a CSV cell: [extract] is a column name (header row) or `col:N`.
String? csvCell(String body, String extract, {String sym = ''}) {
  final lines = body
      .replaceAll('\r\n', '\n')
      .replaceAll('\r', '\n')
      .split('\n')
      .where((l) => l.trim().isNotEmpty)
      .toList();
  if (lines.isEmpty) return null;
  final want = extract.replaceAll('{sym}', sym).trim();
  List<String> split(String line) {
    final out = <String>[];
    final buf = StringBuffer();
    var q = false;
    for (var i = 0; i < line.length; i++) {
      final ch = line[i];
      if (ch == '"') {
        q = !q;
      } else if (ch == ',' && !q) {
        out.add(buf.toString());
        buf.clear();
      } else {
        buf.write(ch);
      }
    }
    out.add(buf.toString());
    return out;
  }

  if (want.startsWith('col:')) {
    final i = int.tryParse(want.substring(4));
    if (i == null || i < 0) return null;
    final row = split(lines.last);
    return i < row.length ? row[i].trim() : null;
  }
  final header = split(lines.first).map((h) => h.trim()).toList();
  final col = header.indexOf(want);
  if (col < 0) return null;
  final row = split(lines.length > 1 ? lines[1] : lines.first);
  return col < row.length ? row[col].trim() : null;
}

/// Minimal CSS: `#id`, `.class`, `tag`, `[attr=value]`, space descendants.
String? cssSelect(String html, String selector, {String attribute = ''}) {
  final sel = selector.trim();
  if (sel.isEmpty) return null;
  final parts = sel.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
  final all = _parseElements(html);
  var pool = all;
  for (var i = 0; i < parts.length; i++) {
    final matched = [for (final e in pool) if (_matchesSimple(e, parts[i])) e];
    if (matched.isEmpty) return null;
    if (i == parts.length - 1) {
      final el = matched.first;
      if (attribute.isNotEmpty) return el.attrs[attribute.toLowerCase()];
      return el.text.trim();
    }
    // Children = elements whose open index is inside this element's span.
    final next = <_El>[];
    for (final parent in matched) {
      for (final child in all) {
        if (child.openStart > parent.openEnd && child.closeEnd <= parent.closeEnd && child != parent) {
          next.add(child);
        }
      }
    }
    pool = next;
  }
  return null;
}

({String? price, String? asOf}) regexExtract(String html, String pattern) {
  final re = RegExp(pattern, dotAll: true);
  final m = re.firstMatch(html);
  if (m == null) return (price: null, asOf: null);
  return (price: _named(m, 'price'), asOf: _named(m, 'as_of'));
}

String? _named(RegExpMatch m, String name) {
  if (!m.groupNames.contains(name)) return null;
  return m.namedGroup(name);
}

class _El {
  _El({
    required this.tag,
    required this.attrs,
    required this.text,
    required this.openStart,
    required this.openEnd,
    required this.closeEnd,
  });
  final String tag;
  final Map<String, String> attrs;
  final String text;
  final int openStart;
  final int openEnd;
  final int closeEnd;
}

/// Stack-based tag scan so nested spans (tgju) resolve correctly.
List<_El> _parseElements(String html) {
  final out = <_El>[];
  final token = RegExp(r'''<!--[\s\S]*?-->|</([A-Za-z][\w:-]*)\s*>|<([A-Za-z][\w:-]*)(\s[^>]*)?(/?)\s*>''', caseSensitive: false);
  final stack = <({String tag, int openStart, int openEnd, Map<String, String> attrs})>[];
  for (final m in token.allMatches(html)) {
    final whole = m.group(0)!;
    if (whole.startsWith('<!--')) continue;
    final closeTag = m.group(1);
    if (closeTag != null) {
      final tag = closeTag.toLowerCase();
      for (var i = stack.length - 1; i >= 0; i--) {
        if (stack[i].tag != tag) continue;
        final open = stack.removeAt(i);
        final inner = html.substring(open.openEnd, m.start);
        final text = inner.replaceAll(RegExp(r'<[^>]+>'), ' ').replaceAll(RegExp(r'\s+'), ' ');
        out.add(
          _El(
            tag: tag,
            attrs: open.attrs,
            text: text,
            openStart: open.openStart,
            openEnd: open.openEnd,
            closeEnd: m.end,
          ),
        );
        break;
      }
      continue;
    }
    final openTag = m.group(2)!.toLowerCase();
    final attrs = _parseAttrs(m.group(3) ?? '');
    final selfClosing = (m.group(4) == '/') || _void.contains(openTag);
    if (selfClosing) {
      out.add(
        _El(tag: openTag, attrs: attrs, text: '', openStart: m.start, openEnd: m.end, closeEnd: m.end),
      );
    } else {
      stack.add((tag: openTag, openStart: m.start, openEnd: m.end, attrs: attrs));
    }
  }
  return out;
}

const _void = {
  'area', 'base', 'br', 'col', 'embed', 'hr', 'img', 'input', 'link', 'meta', 'param', 'source', 'track', 'wbr',
};

Map<String, String> _parseAttrs(String s) {
  final out = <String, String>{};
  final re = RegExp(r'''([A-Za-z_:][\w:.-]*)\s*=\s*(?:"([^"]*)"|'([^']*)'|([^\s>]+))''');
  for (final m in re.allMatches(s)) {
    out[m.group(1)!.toLowerCase()] = m.group(2) ?? m.group(3) ?? m.group(4) ?? '';
  }
  return out;
}

bool _matchesSimple(_El e, String part) {
  final pureAttr = RegExp(r'''^\[([A-Za-z_:][\w:.-]*)=(?:"([^"]*)"|'([^']*)'|([^\]]+))]$''').firstMatch(part);
  if (pureAttr != null) {
    final v = pureAttr.group(2) ?? pureAttr.group(3) ?? pureAttr.group(4) ?? '';
    return e.attrs[pureAttr.group(1)!.toLowerCase()] == v;
  }

  String? tag;
  String? id;
  final classes = <String>[];
  final attrChecks = <(String, String)>[];
  final attrRe = RegExp(r'''\[([A-Za-z_:][\w:.-]*)=(?:"([^"]*)"|'([^']*)'|([^\]]+))]''');

  var rest = part;
  final tagM = RegExp(r'^([A-Za-z][\w:-]*)').firstMatch(rest);
  if (tagM != null) {
    tag = tagM.group(1)!.toLowerCase();
    rest = rest.substring(tag.length);
  }
  for (final m in RegExp(r'''#([A-Za-z_][\w:-]*)|\.([A-Za-z_][\w|-]*)|(\[[^\]]+\])''').allMatches(rest)) {
    if (m.group(1) != null) id = m.group(1);
    if (m.group(2) != null) classes.add(m.group(2)!);
    if (m.group(3) != null) {
      final am = attrRe.firstMatch(m.group(3)!);
      if (am != null) {
        attrChecks.add((am.group(1)!.toLowerCase(), am.group(2) ?? am.group(3) ?? am.group(4) ?? ''));
      }
    }
  }
  if (tag == null && id == null && classes.isEmpty && attrChecks.isEmpty) return false;
  if (tag != null && e.tag != tag) return false;
  if (id != null && e.attrs['id'] != id) return false;
  if (classes.isNotEmpty) {
    final have = (e.attrs['class'] ?? '').split(RegExp(r'\s+')).where((c) => c.isNotEmpty).toSet();
    for (final c in classes) {
      if (!have.contains(c)) return false;
    }
  }
  for (final (k, v) in attrChecks) {
    if (e.attrs[k] != v) return false;
  }
  return true;
}
