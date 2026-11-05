import 'package:flutter/material.dart';
import 'package:kaka_prices/kaka_prices.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/l10n_x.dart';
import '../../core/widgets.dart';

/// Opens [url] in an in-app WebView (user-initiated only) and returns page HTML.
Future<String?> loadHtmlInApp(BuildContext context, {required String url, required String title}) async {
  return showModalBottomSheet<String>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (ctx) => _HtmlLoaderSheet(url: url, title: title),
  );
}

class _HtmlLoaderSheet extends StatefulWidget {
  const _HtmlLoaderSheet({required this.url, required this.title});
  final String url;
  final String title;

  @override
  State<_HtmlLoaderSheet> createState() => _HtmlLoaderSheetState();
}

class _HtmlLoaderSheetState extends State<_HtmlLoaderSheet> {
  late final WebViewController _controller;
  var _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (_) => setState(() {
            _loading = true;
            _error = null;
          }),
          onPageFinished: (_) => setState(() => _loading = false),
          onWebResourceError: (e) => setState(() => _error = e.description),
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  Future<void> _capture() async {
    try {
      final raw = await _controller.runJavaScriptReturningResult(
        r'(function(){return document.documentElement ? document.documentElement.outerHTML : document.body.outerHTML;})()',
      );
      var html = '$raw';
      // Android may wrap the JS string in extra quotes / escapes.
      if (html.length >= 2 && html.startsWith('"') && html.endsWith('"')) {
        html = html.substring(1, html.length - 1).replaceAll(r'\"', '"').replaceAll(r'\n', '\n').replaceAll(r'\\', '\\');
      }
      if (!mounted) return;
      Navigator.pop(context, html);
    } on Object catch (e) {
      setState(() => _error = '$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final h = MediaQuery.sizeOf(context).height * 0.85;
    return SizedBox(
      height: h,
      child: Column(
        children: [
          ListTile(
            title: Text(widget.title),
            subtitle: Text(widget.url, maxLines: 1, overflow: TextOverflow.ellipsis),
            trailing: IconButton(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.close)),
          ),
          if (_loading) const LinearProgressIndicator(minHeight: 2),
          if (_error != null)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
            ),
          Expanded(child: WebViewWidget(controller: _controller)),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: KPrimaryButton(
              onPressed: _loading ? null : _capture,
              child: Text(l.priceUsePage),
            ),
          ),
        ],
      ),
    );
  }
}

/// Preview a parsed HTML price before saving.
Future<bool> confirmParsedPrice(
  BuildContext context, {
  required String label,
  required FetchedPrice fetched,
  required String formatted,
}) async {
  final l = context.l10n;
  final ok = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l.pricePreviewTitle),
      content: Text('$label\n$formatted\n${fetched.asOf.toIso8601String().substring(0, 10)}'),
      actions: [
        TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(l.cancel)),
        FilledButton(onPressed: () => Navigator.pop(ctx, true), child: Text(l.save)),
      ],
    ),
  );
  return ok ?? false;
}
