# پارسرهای قیمت کاکا / Kaka price parsers

کاکا قیمت را **هرگز نمی‌سازد**. منبع قیمت یک فایل JSON است (مثل پارسر پیامک): آدرس + مسیر استخراج. همهٔ منابع آنلاین پیش‌فرض **خاموش**اند. ثبت دستی («ثبت قیمت») همیشه کار می‌کند. آفلاین آخرین قیمت ذخیره‌شده نشان داده می‌شود؛ اگر نباشد «بدون قیمت».

Kaka **never invents** prices. A price source is a JSON file (like SMS parsers): URL + extract path. Online sources are **off by default**. Manual «Set price» always works. Offline shows the last stored quote, or “no price”.

## روشن کردن / Enable

1. دارایی‌ها → قیمت واحد → منابع قیمت  
2. منبع را روشن کن  
3. «وصل کردن دارایی» و نماد منبع را بگذار (برای BTC روی CoinGecko معمولاً `bitcoin`)  
4. به صفحهٔ قیمت برگرد و «به‌روز کردن قیمت» بزن  

برای `http_html` مرورگر داخل برنامه باز می‌شود؛ فقط وقتی خودت بزنی. پس‌زمینه صفحه را نمی‌خواند.

## انواع / Kinds

| kind | توضیح |
|---|---|
| `http_json` | GET یک URL؛ `extract` با JSONPath کوچک |
| `http_csv` | CSV؛ `extract` نام ستون یا `col:N` |
| `http_html` | صفحه وب؛ `css` و/یا `regex` با گروه `price` |
| `manual` | فقط ثبت دستی (همیشه هست) |

Placeholders in URL / extract / css: `{sym}`, `{quote}`, `{id}`.

Optional `as_of_extract` (JSON) stores the source’s own date (e.g. ECB close yesterday), not “now”.

## نمونه API / API example

```json
{
  "schema_version": 1,
  "catalog_version": "my-1",
  "sources": [{
    "id": "my_coingecko",
    "kind": "http_json",
    "name": { "en": "My CoinGecko", "fa": "کوین‌گکوی من" },
    "classes": ["crypto"],
    "url": "https://api.coingecko.com/api/v3/simple/price?ids={sym}&vs_currencies=usd",
    "extract": "$.{sym}.usd",
    "quote_currency": "USD",
    "enabled_by_default": false,
    "symbol_hints": { "BTC": "bitcoin", "ETH": "ethereum" }
  }]
}
```

JSONPath supported: `$.a.b`, `$.a['key-1']`, `$.a[0]`.

## نمونه صفحه وب / HTML example

```json
{
  "schema_version": 1,
  "catalog_version": "my-1",
  "sources": [{
    "id": "my_page",
    "kind": "http_html",
    "name": { "en": "My page", "fa": "صفحه من" },
    "classes": ["metal"],
    "url": "https://example.com/prices",
    "css": "li#l-{sym} span.info-price",
    "regex": "data-price=\"(?<price>[0-9.,]+)\"",
    "attr": "",
    "quote_currency": "IRR",
    "enabled_by_default": false
  }]
}
```

CSS subset: `#id`, `.class`, `tag`, `[attr=value]`, descendant spaces. Regex needs a named group `price` (optional `as_of`).

## خروجی و ورود / Export & import

در منابع قیمت → خروجی، یک فایل JSON می‌گیری و می‌فرستی. طرف مقابل «ورود» می‌کند، منبع را روشن می‌کند و دارایی‌ها را وصل می‌کند. منبع‌های داخلی فقط‌خواندنی‌اند؛ واردشده‌ها قابل حذف‌اند.

Parsers are **data only** — never executable code. Unknown `kind` values are skipped on import so older apps stay safe.

## حریم خصوصی / Privacy

Only the symbol (and URL template) is requested. Holdings, identity, and amounts are never sent.

## منابع پیش‌فرض بسته‌شده / Bundled defaults (all off)

See `packages/kaka_prices/assets/price_sources.v1.json`. Verified where possible from the build host (2026-11-05): CoinGecko, Kraken, Frankfurter, Coinbase XAU. Nobitex and tgju ship as optional community templates (Iran-reachable / HTML); enable at your own choice.

## فرمول مرکب / Composite formulas

`*` and `/` evaluator exists in `kaka_prices` (`evalFormula`) with cycle detection. UI wiring is deferred (TODO).
