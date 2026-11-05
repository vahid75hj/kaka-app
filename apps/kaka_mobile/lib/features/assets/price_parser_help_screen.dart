import 'package:flutter/material.dart';

import '../../core/l10n_x.dart';
import '../../theme/kaka_colors.dart';

/// In-app guide: how to write API and website price parsers.
class PriceParserHelpScreen extends StatelessWidget {
  const PriceParserHelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final c = KakaColors.of(context);
    final fa = Localizations.localeOf(context).languageCode == 'fa';
    Widget code(String s) => Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: c.line),
      ),
      child: SelectableText(s, style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
    );

    return Scaffold(
      appBar: AppBar(title: Text(l.priceParserHelpTitle)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
        children: [
          Text(fa ? _faIntro : _enIntro, style: TextStyle(color: c.textMuted)),
          const SizedBox(height: 16),
          Text(fa ? 'منبع API (http_json)' : 'API sources (http_json)', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(fa ? _faApi : _enApi),
          const SizedBox(height: 12),
          code(_apiExample),
          const SizedBox(height: 20),
          Text(fa ? 'منبع صفحه وب (http_html)' : 'Website sources (http_html)', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(fa ? _faHtml : _enHtml),
          const SizedBox(height: 12),
          code(_htmlExample),
          const SizedBox(height: 20),
          Text(fa ? 'ورود و خروجی' : 'Import / export', style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(fa ? _faShare : _enShare),
        ],
      ),
    );
  }
}

const _enIntro =
    'Price parsers are JSON data — a URL plus an extract path, CSS selector, or regex. '
    'Kaka never runs code from a parser file and never invents prices. Manual «Set price» always works.';

const _faIntro =
    'پارسر قیمت فقط دادهٔ JSON است: یک آدرس به‌علاوه مسیر استخراج، انتخاب‌گر CSS یا regex. '
    'کاکا از فایل پارسر کد اجرا نمی‌کند و هیچ قیمتی نمی‌سازد. «ثبت قیمت» دستی همیشه کار می‌کند.';

const _enApi =
    'kind must be http_json. Put {sym} in the URL for the bound symbol. extract is a tiny JSONPath: '
    r"$.bitcoin.usd or $.stats['btc-rls'].latest. Optional as_of_extract keeps the source date "
    '(e.g. ECB close) instead of “today”.';

const _faApi =
    'kind باید http_json باشد. در URL از {sym} برای نماد استفاده‌کن. extract یک JSONPath کوچک است: '
    r"$.bitcoin.usd یا $.stats['btc-rls'].latest. as_of_extract اختیاری است تا تاریخ خود منبع "
    '(مثلاً نرخ دیروز ECB) ذخیره شود، نه «امروز».';

const _enHtml =
    'kind is http_html. Refresh opens the page in an in-app browser — never in the background. '
    'Use css (e.g. li#l-{sym} span.info-price) and/or regex with a named group (?<price>…). '
    'Optional attr reads an attribute like data-price instead of text.';

const _faHtml =
    'kind برابر http_html است. «به‌روز کردن» صفحه را در مرورگر داخل برنامه باز می‌کند — هرگز در پس‌زمینه. '
    'از css (مثل li#l-{sym} span.info-price) و/یا regex با گروه نام‌دار (?<price>…) استفاده کن. '
    'attr اختیاری است تا به‌جای متن، ویژگی‌ای مثل data-price خوانده شود.';

const _enShare =
    'Export a source to a .json file and send it. The other person Imports it, enables it, and binds '
    'their instruments to symbols. Built-in sources stay read-only; imports are yours to edit or delete. '
    'Full guide: docs/price-parsers.md in the repo.';

const _faShare =
    'یک منبع را به فایل JSON خروجی بگیر و بفرست. طرف مقابل واردش می‌کند، روشن می‌کند و نماد دارایی‌هایش را وصل می‌کند. '
    'منبع‌های داخلی فقط‌خواندنی‌اند؛ واردشده‌ها مال خودت است. راهنمای کامل: docs/price-parsers.md در مخزن.';

const _apiExample = '''
{
  "schema_version": 1,
  "catalog_version": "my-1",
  "sources": [{
    "id": "my_coingecko",
    "kind": "http_json",
    "name": { "en": "My CoinGecko", "fa": "کوین‌گکوی من" },
    "classes": ["crypto"],
    "url": "https://api.coingecko.com/api/v3/simple/price?ids={sym}&vs_currencies=usd",
    "extract": "\$.{sym}.usd",
    "quote_currency": "USD",
    "enabled_by_default": false,
    "symbol_hints": { "BTC": "bitcoin" }
  }]
}''';

const _htmlExample = '''
{
  "schema_version": 1,
  "catalog_version": "my-1",
  "sources": [{
    "id": "my_page",
    "kind": "http_html",
    "name": { "en": "My page", "fa": "صفحه من" },
    "classes": ["metal"],
    "url": "https://example.com/prices",
    "css": "div.price-card span.value",
    "regex": "data-price=\\"(?<price>[0-9.,]+)\\"",
    "quote_currency": "USD",
    "enabled_by_default": false
  }]
}''';
