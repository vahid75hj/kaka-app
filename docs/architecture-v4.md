# معماری کاکا — نسخهٔ ۴ (آفلاین، متن‌باز، جهانی)
تاریخ تصمیم‌ها: ۲۳ اکتبر ۲۰۲۶ (۲ آبان ۱۴۰۵). هر جا با v3 تعارض دارد، این سند معتبر است.

## 0. خلاصهٔ تصمیم‌ها (TL;DR)
| موضوع | تصمیم v4 |
|---|---|
| هدف | **رایگان و متن‌باز** روی GitHub، نمونه‌کار وحید؛ بدون پرداخت و بدون مدل درآمدی |
| سرور | **هیچ**. بدون حساب کاربری. Serverpod، sync رمزشدهٔ سرور، امانت کلید/OpenBao، OTP و LLM gateway حذف شدند |
| دیتابیس | Drift روی SQLite رمزشده (SQLCipher / SQLite3MultipleCiphers)، کلید در Android Keystore؛ **منبع حقیقت = گوشی** |
| پشتیبان | فایل export رمزشده (`.kaka`: Argon2id + XChaCha20-Poly1305) از طریق SAF |
| همگام‌سازی | اختیاری: **Google Sheets در Drive خود کاربر** با scope `drive.file`؛ شیت فقط آینه + تب «Inbox» |
| AI | **BYO-AI**: (الف) کلید API هر سرویس OpenAI-compatible، (ب) مدل روی گوشی (pluggable registry)، (ج) سرور محلی مثل Ollama، (د) بدون AI. حلقهٔ tool-calling روی دستگاه |
| MCP | مجموعه ابزار پایدار `kaka-tools` (JSON Schema واحد)؛ فاز ۱ companion دسکتاپ (stdio)؛ بعداً Android AppFunctions |
| ورودی/خروجی | Share intent (`ACTION_SEND`، `ACTION_PROCESS_TEXT`)، deep link `kaka://`؛ پارس پیامک بانک‌های ایرانی بدون AI |
| جهانی‌سازی | فارسی + انگلیسی (gen-l10n/ARB، RTL/LTR)، تقویم جلالی + میلادی، ارز پایه و تعداد اعشار انتخابی، چندارزی |
| پول | عدد صحیح در واحد خرد (`int64 amount_minor`) + `scale` به ازای هر ارز؛ تومان = واحد نمایشی ریال |
| قیمت‌ها | منابع عمومی رایگان (تأییدنشده)، ورود دستی نرخ، کار آفلاین با آخرین نرخ |
| باقی‌مانده از v3 | دفتر دوطرفه (transaction + postings اتمی، void/tombstone)، UUIDv7، صف سؤال (`pending_questions`)، تم با `ThemeExtension` (تاریک/روشن + monochrome پیش‌فرض، orange، lime، blue) |

## 1. نمای کلی
```
┌──────────── گوشی (Flutter) ────────────┐
│ UI (Riverpod) ── l10n/format ── Theme  │
│ LedgerService · QuestionService        │
│ Importers: SMS / Share / CSV / Inbox   │
│ AI: AiProvider ─┬ RemoteOpenAICompat   │
│                 ├ LocalModelRuntime*   │
│                 └ None                 │
│ ToolRunner (kaka-tools) ── Drift+SQLCipher
│ SheetsMirror (اختیاری) · Backup · Rates│
└───────┬────────────────┬───────────────┘
        │ HTTPS اختیاری  │ فایل .kaka / Sheet
  Google Sheets   Price sources   kaka-mcp (دسکتاپ, stdio) ⇐ Claude Desktop/Cursor
```
اپ بدون هیچ اتصال شبکه کامل کار می‌کند. هر قابلیت شبکه‌ای (Sheets، قیمت، AI ابری، دانلود مدل) جدا و قابل خاموش کردن است.

## 2. ساختار ماژول‌ها و پوشه‌ها (monorepo با melos)
```
kaka/
  apps/
    mobile/                  # Flutter app (Android-first)
      lib/
        app/                 # router, DI (Riverpod), bootstrap
        features/
          onboarding/  home/  accounts/  transactions/  questions/
          reports/  chat/  settings/  import/  ai_models/  sync_sheets/  backup/
        l10n/                # app_fa.arb, app_en.arb (gen-l10n)
        theme/               # KakaColors/KakaTypography ThemeExtension، accents
      android/               # Kotlin: share targets، (بعداً) AppFunctions
    mcp_desktop/             # Dart CLI: kaka-mcp (stdio) — خواندن .kaka یا Sheet
  packages/
    kaka_core/               # Dart خالص: Ledger، Money، Currency، rules، dedup
    kaka_db/                 # Drift schema، migrations، DAOs
    kaka_i18n/               # Jalali/Gregorian، NumberFormatter، digits
    kaka_sms/                # پارسرهای regex بانک‌های ایرانی + fixtures
    kaka_tools/              # schema ابزارها (JSON) + پیاده‌سازی مشترک
    kaka_ai/                 # AiProvider، tool loop، prompt templates
    kaka_local_models/       # ModelRegistry، LocalModelRuntime، adapters، eval
    kaka_sheets/             # Sheets mirror + Inbox validator
    kaka_backup/             # فرمت .kaka، رمزنگاری
    kaka_rates/              # RateSource adapters، کش آفلاین
  model_catalog/
    catalog.v1.json          # manifest مدل‌ها (همان که اپ remote می‌خواند)
    eval/fa_testset.jsonl    # مجموعه تست فارسی
  docs/  .github/workflows/
```
`kaka_core`، `kaka_tools` و `kaka_backup` Dart خالص‌اند تا هم اپ و هم `kaka-mcp` دسکتاپ از آن‌ها استفاده کنند.

## 3. مدل داده — تغییرات برای ارز و اعشار
### 3.1 اصل: پول = عدد صحیح
- هر مبلغ `amount_minor INTEGER` (int64) + `currency TEXT` (ISO 4217). هرگز double.
- `scale` = تعداد رقم اعشار ذخیره‌شده برای آن ارز. مقدار واقعی = `amount_minor / 10^scale`.
- **scale ذخیره‌سازی با scale نمایش فرق دارد.** کاربر در onboarding «تعداد اعشار نمایش» را انتخاب می‌کند؛ scale ذخیره‌سازی برای هر ارز در ساخت دفتر ثابت می‌شود (پیش‌فرض = ISO minor unit، مثلاً USD/EUR/AED = 2، IRR = 0) و تغییرش فقط با migration کنترل‌شده (ضرب در 10^k، بدون از دست رفتن دقت؛ کاهش scale فقط اگر همهٔ مقادیر بخش‌پذیر باشند). این جلوی خراب شدن داده با عوض کردن یک تنظیم ساده را می‌گیرد.

### 3.2 تومان
- **تصمیم:** تومان ارز ذخیره‌سازی نیست. همه چیز با `IRR` (scale 0) ذخیره می‌شود؛ `IRT` یک **واحد نمایش** است (`÷10`). کاربر «تومان» را به‌عنوان واحد پایه انتخاب می‌کند ⇐ `base_currency = IRR`، `display_unit = IRT`.
- ورودی کاربر به تومان ×10 به ریال تبدیل می‌شود؛ پیامک‌های بانکی (معمولاً ریال) بی‌تغییر ذخیره می‌شوند. دلیل: یک ارز واقعی، بدون ابهام در تبدیل/پیامک، و آمادگی برای تغییر واحد پول ملی (حذف صفرها) با یک `display_unit` جدید.
- اگر مبلغ تومانی با اعشار وارد شود (مثلاً ۱۲٫۵ تومان) ⇐ ۱۲۵ ریال، دقیق.

### 3.3 جدول‌ها (جدید/تغییریافته)
```
currencies(code PK, kind 'fiat'|'custom', storage_scale INT, symbol_fa, symbol_en,
           name_fa, name_en, is_builtin BOOL)              -- داخلی: IRR, USD, EUR, AED (+ IRT در display_units)
display_units(code PK, base_currency FK, factor_pow10 INT) -- IRT → IRR, factor 1 (÷10)
settings(singleton): locale 'fa'|'en', calendar 'jalali'|'gregorian', base_currency, display_unit NULL,
           display_decimals INT, digits 'persian'|'latin', group_separator, decimal_separator,
           first_day_of_week, theme_mode, accent
accounts(+ currency FK)                       -- هر حساب یک ارز؛ کاربر چند حساب با ارزهای مختلف
postings(id UUIDv7, txn_id, account_id, amount_minor INT64, currency,
         base_amount_minor INT64 NULL, rate_id FK NULL)   -- معادل در ارز پایه برای گزارش
transactions: قانون تراز به ازای هر ارز: Σ amount_minor = 0 در هر currency.
   تراکنش چندارزی (تبدیل) ⇐ از حساب‌های واسط `FX:<cur>` استفاده می‌کند تا هر ارز جداگانه تراز باشد.
exchange_rates(id UUIDv7, base, quote, rate_num INT64, rate_scale INT, as_of, source 'manual'|<source_id>, fetched_at)
asset_types(code PK, kind 'gold'|'coin'|'custom', unit 'gram'|'piece'|'mithqal'|…, qty_scale INT,
            name_fa, name_en, is_builtin BOOL)            -- gold18_g, gold24_g, coin_emami, coin_bahar, coin_half, coin_quarter, coin_gerami, …
asset_holdings(id UUIDv7, asset_type FK, account_id FK NULL, label, qty_minor INT64,
               cost_basis_minor INT64 NULL, cost_currency NULL, acquired_at NULL,
               valuation 'auto'|'manual', manual_price_minor INT64 NULL, manual_price_currency NULL,
               note, created_at, updated_at, deleted_at NULL)
asset_movements(id UUIDv7, holding_id FK, qty_delta_minor INT64, txn_id FK NULL, at, note)
   -- خرید/فروش طلا: تراکنش پولی در دفتر (پرداخت/دریافت ریالی) + movement مقدار، با txn_id مشترک
price_quotes(id UUIDv7, asset_type FK, currency, amount_minor, as_of, source 'manual'|<source_id>, fetched_at)
```
- **طلا و سکه ارز نیستند؛ دارایی‌اند.** کاربر مقدار را ثبت می‌کند (مثلاً «۱۰ گرم طلای ۱۸» یا «۲ سکه امامی»)، نه مبلغ. ارزش = `qty × price` به ارز پایه، با این اولویت: قیمت دستی holding (`valuation='manual'`) ⇐ آخرین `price_quotes` (روز یا آخرین دریافت‌شده، با برچسب تاریخ/«قدیمی») ⇐ اگر قیمتی نبود: «بدون قیمت» (در جمع دارایی‌ها حساب نمی‌شود، با هشدار).
- ارزش دارایی‌ها در دفتر دوطرفه ثبت نمی‌شود (تغییر قیمت تراکنش نیست)؛ فقط در گزارش «دارایی خالص» = مانده حساب‌ها + ارزش روز دارایی‌ها. سود/زیان تحقق‌نیافته از `cost_basis` محاسبه می‌شود.
- انواع دارایی قابل گسترش: کاربر می‌تواند نوع سفارشی (مثلاً نقره، رمزارز به‌صورت دارایی) با واحد و قیمت دستی بسازد.
- نرخ‌ها هم به‌صورت عدد صحیح + scale (بدون double).
- گزارش‌ها به ارز پایه با نرخ روز تراکنش (اگر نبود: آخرین نرخ قبل) و برچسب «نرخ تقریبی/قدیمی».
- فهرست ارزها قابل گسترش: ارزهای داخلی اولیه IRR، IRT (واحد نمایشی ریال)، USD، EUR و AED هستند؛ افزودن ارز داخلی جدید (مثلاً GBP، TRY) فقط یک ردیف seed است و کاربر هم می‌تواند ارز سفارشی (مثلاً USDT) اضافه کند.

### 3.4 قالب‌بندی اعداد (`kaka_i18n`)
- `MoneyFormatter(locale, digits, separators, display_decimals, unit)`: ارقام فارسی (۰-۹) یا لاتین، جداکنندهٔ هزارگان (`٬` یا `,`)، اعشار (`٫` یا `.`)، جای نماد ارز طبق locale.
- پارسر ورودی هر دو نوع رقم (و ارقام عربی ٠-٩) را می‌پذیرد.
- تقویم: `shamsi_date` یا معادل برای جلالی؛ همهٔ تاریخ‌ها UTC/epoch ذخیره، نمایش با تقویم انتخابی. گزارش ماهانه بر اساس ماه همان تقویم.

## 4. جریان Onboarding (۴ صفحه، بدون ثبت‌نام)
1. **زبان:** فارسی / English (پیش‌فرض از locale گوشی) ⇐ جهت RTL/LTR فوری عوض می‌شود.
2. **منطقه و نمایش:** تقویم (جلالی/میلادی؛ پیش‌فرض بر اساس زبان)، ارقام (فارسی/لاتین)، پیش‌نمایش زندهٔ عدد `۱٬۲۳۴٬۵۶۷٫۸۹`.
3. **ارز پایه و اعشار:** ریال، تومان، دلار، یورو، درهم (+ ارزهای سفارشی؛ لیست قابل جستجو)؛ تعداد اعشار نمایش (۰–۴، پیش‌فرض ارز). توضیح کوتاه: «تومان فقط نمایش است؛ داده به ریال ذخیره می‌شود».
4. **امنیت و شروع:** قفل اپ (بیومتریک/PIN، پیش‌فرض روشن)، ساخت اولین حساب (نام، ارز، موجودی اولیه)، و کارت‌های اختیاری «بعداً»: AI، Sheets، پشتیبان. هیچ قابلیت شبکه‌ای در onboarding خودکار روشن نمی‌شود.
همهٔ این‌ها بعداً از تنظیمات قابل تغییرند (جز storage_scale، §3.1).

## 5. پشتیبان
- `.kaka` = header (magic، version، kdf params) + بدنهٔ رمزشده (dump JSON/SQLite دفتر). کلید از passphrase با Argon2id؛ AEAD با XChaCha20-Poly1305 (`sodium_libs` یا `cryptography`).
- ذخیره با SAF (حافظه، Drive، تلگرام…). یادآور دوره‌ای پشتیبان. بازگردانی روی گوشی جدید = تنها راه انتقال در MVP.
- فرمت مستند و پایدار است چون `kaka-mcp` دسکتاپ هم آن را می‌خواند (فقط خواندنی).

## 6. همگام‌سازی اختیاری با Google Sheets
- ورود با Google Sign-In، scope **`drive.file`** (فقط فایل‌هایی که کاکا ساخته؛ نیاز به verification سنگین ندارد — باید در Google Cloud Console تأیید شود).
- کاکا یک spreadsheet «Kaka Ledger» در Drive کاربر می‌سازد با تب‌ها: `Accounts`، `Transactions` (هر posting یک ردیف، شامل `id`)، `Rates`، `Meta` (schema_version، last_push)، و **`Inbox`**.
- **جهت داده:** DB محلی منبع حقیقت؛ تب‌های آینه یک‌طرفه بازنویسی می‌شوند (تغییر دستی کاربر در آن‌ها نادیده/بازنویسی می‌شود؛ هشدار در Meta).
- **Inbox:** ستون‌ها `date, description, amount, currency, account, category, note, source, status, kaka_id`. هر کس (کاربر، Gemini در Sheets، ChatGPT/Claude با کانکتور) می‌تواند ردیف اضافه کند. کاکا در sync: اعتبارسنجی (تاریخ، عدد، ارز، حساب موجود، dedup) ⇐ سؤال در `pending_questions` نوع `inbox_row` ⇐ با تأیید کاربر ثبت، و `status` = `imported`/`rejected` + `kaka_id` در شیت. ردیف نامعتبر `status=error: …`.
- متن Inbox داده‌ی غیرقابل‌اعتماد است (prompt injection): هرگز به‌عنوان دستور به مدل داده نمی‌شود.
- ⚠️ **ریسک ایران:** دسترسی به Google APIs از IP ایران احتمالاً مسدود است (تحریم سمت گوگل + فیلترینگ) ⇐ بدون VPN کار نمی‌کند؛ باید تست شود. Sheets هرگز پیش‌فرض نیست.
- ⚠️ داده در شیت رمزشده نیست؛ در UI صریح گفته می‌شود.
- اینکه کانکتورهای ChatGPT/Claude **نوشتن** در Sheets را پشتیبانی می‌کنند تأیید نشده.

## 7. هوش مصنوعی (BYO-AI)
### 7.1 لایهٔ مشترک
```dart
abstract class AiProvider {            // چت + tool calling
  Stream<AiEvent> chat(List<Msg> msgs, {List<ToolSpec> tools, AiOptions opts});
  Future<AiCapabilities> capabilities();
}
```
پیاده‌سازی‌ها: `OpenAICompatProvider` (base URL + key + model؛ Gemini OpenAI-compat endpoint، OpenRouter، DeepSeek، Groq و…؛ کلید در Keystore)، `LocalModelProvider` (روی `LocalModelRuntime`، §7.3)، `OllamaProvider` (همان OpenAI-compat روی LAN/localhost)، `NoAiProvider`.
- **حلقهٔ tool-calling روی دستگاه** (= v3، حداکثر ~۵ دور): مدل ابزارهای `kaka_tools` را صدا می‌زند، `ToolRunner` روی Drift اجرا می‌کند. ابزارهای نوشتن فقط پیش‌نویس در صف سؤال می‌سازند.
- مدل‌هایی که tool-calling ندارند ⇐ حالت «aggregates-in-prompt» (خلاصهٔ محاسبه‌شده در prompt) یا فقط extraction با خروجی JSON محدود.
- ماسک شماره کارت/حساب/شبا/کد ملی قبل از ارسال به هر provider ابری (روشن پیش‌فرض).
- (د) بدون AI: همهٔ ورود، پارس پیامک، گزارش و صف سؤال بدون AI کار می‌کنند؛ تب چت مخفی می‌شود.

### 7.2 رجیستری مدل‌های روی گوشی (pluggable)
مدل‌ها در کد hard-code نمی‌شوند؛ از یک **manifest JSON نسخه‌دار** می‌آیند.
- منابع: (۱) `catalog.v1.json` همراه اپ (bundled default)، (۲) به‌روزرسانی اختیاری از `raw.githubusercontent.com/<org>/kaka/main/model_catalog/catalog.v1.json` (و mirror روی GitHub Releases)، (۳) مدل‌های سفارشی کاربر. ادغام بر اساس `id` + `version`؛ remote فقط اگر `schema_version` پشتیبانی شود و امضای اختیاری/checksum فایل catalog معتبر باشد.
- افزودن مدل جدید = یک PR به `catalog.v1.json` (بدون تغییر کد)، به شرط وجود adapter برای runtime آن.

نمونهٔ ورودی:
```json
{
  "schema_version": 1,
  "catalog_version": "2026.10.23",
  "models": [{
    "id": "gemma-4-e2b-it-int4",
    "version": 1,
    "name": {"fa": "Gemma 4 سبک", "en": "Gemma 4 E2B (light)"},
    "family": "gemma",
    "runtime": "litert_lm",
    "format": "litertlm",
    "size_bytes": 0,
    "quantization": "int4",
    "min_ram_mb": 6144,
    "min_android_sdk": 28,
    "accelerators": ["gpu", "cpu"],
    "languages": ["en", "fa", "multi"],
    "capabilities": ["chat", "tool_calling", "extraction"],
    "context_tokens": 8192,
    "prompt_template": {"type": "builtin", "name": "gemma"},
    "downloads": [
      {"url": "https://huggingface.co/<repo>/<file>", "kind": "primary"},
      {"url": "https://github.com/<org>/kaka-models/releases/download/<tag>/<file>", "kind": "mirror"}
    ],
    "sha256": "<hex>",
    "license": {"id": "gemma", "url": "https://ai.google.dev/gemma/terms", "requires_acceptance": true},
    "tier": "light",
    "eval": {"fa_testset_v1": {"extraction_acc": null, "tool_call_acc": null}}
  }]
}
```
(اعداد اندازه/URL نمونه‌اند؛ مقادیر واقعی بعد از spike پر می‌شوند. پیشنهاد اولیه: یک مدل سبک ~۱GB و یک مدل بهتر ~۳–۴GB از خانوادهٔ Gemma.)
- `prompt_template` می‌تواند `builtin` (gemma، llama3، chatml، qwen) یا `inline` (Jinja-like با `{{system}}/{{messages}}/{{tools}}`) باشد.
- ⚠️ لایسنس: باز توزیع وزن‌ها در GitHub Releases باید با لایسنس هر مدل (مثلاً Gemma Terms) سازگار باشد؛ کاربر قبل از دانلود لایسنس را می‌بیند.

### 7.3 لایهٔ runtime
```dart
abstract class LocalModelRuntime {
  String get id;                                   // 'litert_lm' | 'llama_cpp' | 'openai_compat'
  bool supports(ModelManifest m);                  // format/runtime match
  Future<DeviceFit> checkDevice(ModelManifest m);  // RAM، فضای خالی، SDK، GPU ⇒ ok/warn/block
  Future<LoadedModel> load(ModelManifest m, File weights, RuntimeOptions o);
}
abstract class LoadedModel {
  Stream<String> generate(PromptInput in, GenOptions o);   // template از manifest
  Future<ToolCallResult?> generateWithTools(...);          // اگر capability داشته باشد
  Future<void> unload();
}
```
Adapterها: `FlutterGemmaRuntime` (LiteRT-LM / `.task`/`.litertlm` از طریق `flutter_gemma`) در MVP؛ `LlamaCppRuntime` (GGUF از طریق یک binding مثل `llama_cpp_dart`/`fllama` — **تأییدنشده**، باید spike شود) فاز بعد؛ `OpenAICompatRuntime` برای Ollama/LM Studio/llama-server روی localhost یا LAN. فرمت جدید = فقط یک adapter جدید + ثبت در `RuntimeRegistry`.

### 7.4 دانلود و مدیریت
- `ModelDownloadService`: دانلود قابل ادامه (Range)، ابتدا primary سپس mirrorها به ترتیب (fallback خودکار اگر Hugging Face از ایران فیلتر بود)، تأیید **sha256** قبل از فعال‌سازی، ذخیره در حافظهٔ داخلی اپ، فقط روی Wi‑Fi (قابل تغییر)، حذف از تنظیمات.
- قبل از دانلود: `checkDevice` ⇒ پیشنهاد مدل مناسب (light/better) و هشدار باتری/حرارت.
- **مدل سفارشی:** کاربر URL یا فایل محلی (SAF) + runtime/format + template را وارد می‌کند (یا یک قطعه manifest JSON paste می‌کند). checksum اختیاری ولی توصیه‌شده؛ برچسب «تأییدنشده».

### 7.5 بررسی توانایی و ارزیابی
- capabilityها از manifest خوانده و در اولین بار با **probe** کوتاه تأیید می‌شوند (مثلاً یک tool call ساده، یک extraction JSON). اگر probe شکست خورد، قابلیت آن مدل در UI غیرفعال (مثلاً چت بدون ابزار).
- **Eval hook:** `ModelEvaluator.run(model, testset)` روی `fa_testset.jsonl` (پیامک‌های بانکی، سؤالات کوتاه فارسی، tool calls نمونه، تاریخ جلالی) ⇒ دقت extraction، دقت tool call، tokens/s، RAM پیک. از تنظیمات (حالت توسعه‌دهنده) و در CI دسکتاپ (برای runtimeهای قابل اجرا روی لینوکس، مثل llama.cpp/Ollama) اجرا می‌شود؛ نتایج در `eval` manifest ثبت می‌شوند تا کاربر عدد واقعی ببیند.

## 8. ابزارهای کاکا (`kaka-tools`) و MCP
یک schema واحد (JSON Schema در `packages/kaka_tools/schema/`) برای سه مصرف‌کننده: حلقهٔ AI داخل اپ، `kaka-mcp` دسکتاپ، AppFunctions آینده. نسخه‌دار (`tools_version`)؛ تغییر ناسازگار = ابزار جدید.
| ابزار | نوع | توضیح |
|---|---|---|
| `get_balance` | read | موجودی حساب(ها)، به ارز خود حساب + ارز پایه |
| `list_accounts` | read | |
| `list_transactions` | read | فیلتر تاریخ (جلالی/میلادی)، حساب، دسته، مبلغ، متن؛ pagination |
| `summarize_spending` | read | جمع به تفکیک دسته/ماه |
| `get_rates` | read | آخرین نرخ‌ها و تاریخشان |
| `list_categories` | read | |
| `add_transaction` | write-draft | **فقط پیش‌نویس در صف سؤال؛ نیاز به تأیید کاربر** |
| `list_pending_questions` | read | |
- مبالغ در خروجی ابزار: `{amount_minor, currency, scale, formatted}` تا مدل اشتباه اعشار نکند.
- **فاز ۱ — `kaka-mcp` دسکتاپ (stdio):** برنامهٔ Dart compile‌شده (Linux/macOS/Windows) با `kaka-mcp --backup path.kaka` (passphrase از prompt/keychain) یا `--sheet <id>`. ابزارهای read مستقیم؛ `add_transaction` روی دسکتاپ به‌صورت ردیف در تب Inbox شیت یا فایل `inbox.jsonl` کنار پشتیبان نوشته می‌شود و در گوشی تأیید می‌شود. نمونهٔ config برای Claude Desktop/Cursor در README.
- **بعداً:** Android AppFunctions (Kotlin، `androidx.appfunctions`) وقتی فراتر از testerهای Gemini باز شد؛ همان schema. پل MCP راه دور (tunnel + OAuth) فقط opt-in و با برچسب «آفلاین نیست».

## 9. ورودی/خروجی با Share و پیامک
- `ACTION_SEND` (text) و `ACTION_PROCESS_TEXT` («افزودن به کاکا»): متن ⇐ پارسر پیامک ⇐ اگر نشد و AI فعال بود، extraction با AI ⇐ کارت تأیید / صف سؤال.
- بلوک ساختاریافتهٔ `kaka-import` (JSON داخل متن) و deep link `kaka://add?...` تا جواب هر AI با یک ضربه وارد شود؛ پرامپت آماده برای کپی در ChatGPT و… .
- خروجی: Share خلاصه/CSV + پرامپت آماده.
- `kaka_sms`: پارسر پیامک بانکی مبتنی بر قالب‌های اعلانی (declarative)، **بدون AI** — جزئیات در §9.1.

### 9.1 پارسر پیامک بانکی (قالب‌محور، قابل گسترش)

**اصل:** پارسر = داده، نه کد. هر بانک یک قالب JSON است؛ افزودن بانک نیازی به تغییر کد یا انتشار نسخهٔ جدید اپ ندارد.

**کاتالوگ `sms-parsers.v1.json`** (هم‌الگو با `catalog.v1.json` مدل‌ها):
- نسخه‌دار (`schema_version`، `catalog_version`)، داخل اپ bundle می‌شود و اختیاری از GitHub (Raw/Releases، با بررسی امضا/hash) به‌روز می‌شود؛ نسخهٔ bundle همیشه fallback است.
- هر entry:
  - `bank_id`، `name` (`fa`/`en`)، `senders` (شماره‌ها/شناسه‌های فرستنده، مثلاً الگوی `+98...` یا نام متنی)
  - `kind` (برداشت/واریز/عمومی) و `templates[]`؛ هر قالب یا `regex` با named group است یا `field_template` توکنی (مثل `{amount} ریال برداشت از {last4}`)
  - فیلدها: `amount`، `direction` (`debit`/`credit` + کلیدواژه‌ها مثل «برداشت/واریز/-/+»)، `balance`، `date`، `time`، `last4` (کارت/حساب)، `description`
  - `locale`: نرمال‌سازی ارقام فارسی (۰–۹) و عربی (٠–٩)، جداکنندهٔ هزارگان (`,` `٬` `.`)، تاریخ جلالی/میلادی، واحد (ریال پیش‌فرض)
  - `samples[]` (پیامک نمونه با شماره‌های ماسک‌شده) و `tests[]` (ورودی ⇐ خروجی مورد انتظار)
  - `status`: `verified` | `needs_samples` | `community`، و `trust` پیش‌فرض
- **CI:** روی هر PR، schema validate می‌شود و همهٔ `tests` هر قالب اجرا می‌شوند؛ قالب بدون نمونه/تست رد می‌شود. مشارکت جامعه = PR به ریپو (با الگوی issue «افزودن بانک»؛ راهنما در `CONTRIBUTING.md` برای ماسک کردن داده‌ها).

**بانک‌های MVP:** ملی، ملت، صادرات، تجارت، پاسارگاد (قابل گسترش). ⚠️ **فرمت واقعی پیامک‌ها را حدس نمی‌زنیم**؛ این ۵ قالب با `status: needs_samples` ساخته می‌شوند و تا دریافت پیامک واقعی (ماسک‌شده) از کاربران/خودمان، فعال پیش‌فرض نیستند.

**جریان «افزودن بانک جدید»:**
1. کاربر ۳–۵ پیامک از همان بانک را paste یا (با مجوز) از صندوق پیامک انتخاب می‌کند.
2. **(الف) بدون AI:** نرمال‌سازی ارقام ⇐ توکن‌سازی ⇐ diff و token alignment بین پیامک‌ها ⇐ پیشنهاد بخش‌های ثابت و متغیر ⇐ تشخیص خودکار نوع متغیرها (عدد/مبلغ، تاریخ، ساعت، ۴ رقم) ⇐ UI ساده که کاربر روی هر بخش متغیر ضربه می‌زند و برچسب می‌دهد (مبلغ، مانده، تاریخ، …) و کلیدواژهٔ برداشت/واریز را مشخص می‌کند.
3. **(ب) با AI (اگر provider فعال باشد):** شماره کارت/حساب/شبا قبل از ارسال ماسک می‌شوند؛ AI قالب پیشنهادی (همان schema) برمی‌گرداند. خروجی AI فقط پیشنهاد است.
4. **در هر دو حالت:** اعتبارسنجی قالب روی همهٔ نمونه‌ها (باید همه match شوند) ⇐ پیش‌نمایش جدول نتایج ⇐ ذخیرهٔ محلی (`status: local`) ⇐ اختیاری: export/share به‌صورت JSON یا ارسال به ریپو (باز کردن PR/issue از مرورگر با متن آماده؛ هیچ چیز خودکار ارسال نمی‌شود).

**تأیید، اطمینان و تکرار:**
- نتیجهٔ پارس همیشه به **صف سؤال** می‌رود تا قالب «مورد اعتماد» شود (مثلاً پس از N=۵ تأیید بدون اصلاح؛ کاربر می‌تواند ثبت خودکار را برای آن بانک روشن کند).
- **امتیاز اطمینان (۰–۱):** تطابق کامل regex، فرستندهٔ شناخته‌شده، سازگاری مانده (مانده قبلی ± مبلغ = مانده جدید)، معتبر بودن تاریخ، و سابقهٔ تأیید قالب. زیر آستانه ⇐ همیشه صف سؤال.
- **Dedup:** کلید `hash(bank_id, last4, amount, direction, datetime)` + پنجرهٔ زمانی؛ جلوگیری از ثبت دوباره از مسیرهای SMS/Share/notification و تشخیص پیامک تکراری.
- **تغییر فرمت بانک:** وقتی پیامک از فرستندهٔ شناخته‌شده با هیچ قالبی match نشد ⇐ fallback به AI extraction (اگر فعال) یا ورود دستی از صف سؤال ⇐ شمارش شکست‌ها؛ پس از چند شکست، اپ پیشنهاد «یادگیری دوباره» (همان جریان افزودن بانک با پیامک‌های جدید) و گزارش به ریپو را می‌دهد. قالب قدیمی نگه داشته می‌شود (versioned) تا پیامک‌های قدیمی هم پارس شوند.

**مجوز SMS اندروید و سیاست Google Play:**
- Google Play `READ_SMS`/`RECEIVE_SMS` را فقط برای اپ پیش‌فرض SMS/موارد استثنا مجاز می‌داند؛ اپ مالی معمولاً رد می‌شود.
- چون توزیع ما **GitHub Releases و F-Droid** است، `READ_SMS` (خواندن صندوق برای انتخاب نمونه/import تاریخچه) و `RECEIVE_SMS` (پارس لحظه‌ای) ممکن است — با درخواست صریح، قابل خاموش شدن، و فقط پردازش محلی.
- جایگزین‌ها (برای build احتمالی Play یا کاربرانی که مجوز نمی‌دهند): Share/`ACTION_PROCESS_TEXT`، و `NotificationListenerService` (خواندن اعلان پیامک با اجازهٔ کاربر؛ متن ممکن است کوتاه‌شده باشد).
- flavorها: `full` (با SMS) و `play` (بدون SMS permission).

## 10. نرخ ارز و قیمت دارایی‌ها (طلا/سکه)
- `RateSource` interface + adapterها؛ هیچ داده‌ای از کاربر ارسال نمی‌شود. کش در `exchange_rates`/`price_quotes`؛ آفلاین ⇐ آخرین نرخ با تاریخ و برچسب «قدیمی».
- ورود دستی نرخ همیشه ممکن و اولویت‌دار (per-date).
- کاندیداها (**همه تأییدنشده** از نظر رایگان بودن، پایداری، شرایط استفاده و دسترسی از ایران):
  - نرخ ارزهای بین‌المللی: Frankfurter (داده‌های ECB)، `fawazahmed0/exchange-api` (CDN jsDelivr)، open.er-api.com.
  - بازار آزاد ایران و طلا/سکه: صفحات/APIهای عمومی سایت‌هایی مثل tgju، bonbast و ریپوهای متن‌باز اسکریپر در GitHub — احتمالاً بدون API رسمی؛ scraping شکننده و ممکن است مغایر شرایط آن سایت‌ها باشد.
- منبع در تنظیمات قابل انتخاب/خاموش؛ پیش‌فرض: فقط دستی تا منبع تأیید شود.

## 11. امنیت
- DB رمزشده با کلید Keystore؛ قفل اپ؛ `FLAG_SECURE` اختیاری؛ کلیدهای API در `flutter_secure_storage`.
- هر داده‌ای که به AI ابری، Sheets یا MCP برود از ضمانت حریم خصوصی کاکا خارج است ⇐ پیش‌فرض خاموش، توضیح صریح.
- متن پیامک/Inbox/یادداشت = داده، نه دستور؛ نوشتن‌ها همیشه با تأیید کاربر.
- بدون telemetry. وابستگی‌ها با Dependabot.

## 12. دامنهٔ MVP و فازها
| فاز | محتوا |
|---|---|
| **MVP (v0.1)** | onboarding (زبان، تقویم، ارقام، ارز پایه، اعشار)؛ fa/en کامل RTL/LTR؛ دفتر دوطرفه چندارزی؛ حساب/دسته/تراکنش؛ صف سؤال؛ پارسر پیامک ۳–۵ بانک + Share-in/`PROCESS_TEXT`؛ Share-out CSV/خلاصه؛ گزارش ماهانه ساده؛ پشتیبان `.kaka`؛ نرخ دستی + یک منبع عمومی؛ تم‌ها؛ BYO-AI (الف) و (د) با tool loop |
| **v0.2** | مدل روی گوشی: registry + `FlutterGemmaRuntime` + دانلود با mirror + checksum + probe؛ (ج) Ollama؛ `kaka-mcp` دسکتاپ خواندنی روی `.kaka` |
| **v0.3** | Google Sheets mirror + Inbox؛ `kaka-mcp --sheet` با `add_transaction`؛ eval فارسی در CI؛ مدل سفارشی |
| **بعداً** | `LlamaCppRuntime` (GGUF)؛ AppFunctions؛ iOS/دسکتاپ؛ بودجه؛ import صورتحساب Excel/CSV؛ انتقال LAN/QR بین گوشی‌ها؛ زبان‌های بیشتر (ARB) |

## 13. برنامهٔ ریپوی متن‌باز
- **لایسنس: MIT** (تصمیم‌گرفته‌شده؛ ساده‌ترین و شناخته‌شده‌ترین، مناسب نمونه‌کار؛ فایل `LICENSE` در ریشهٔ ریپو + هدر کوتاه در README). وزن مدل‌ها جزو ریپو نیستند و لایسنس خودشان را دارند.
- **README:** GIF دمو دوزبانه؛ «آفلاین، بدون حساب، بدون سرور»؛ BYO-AI با ۴ حالت؛ «با Claude/Cursor از حساب‌هایت بپرس» (MCP)؛ مدل‌های pluggable؛ دفتر دوطرفه؛ جلالی/فارسی؛ معماری (نمودار Mermaid)؛ Quick start؛ «افزودن بانک/مدل/زبان» برای مشارکت.
- **CI (GitHub Actions):** `melos analyze` + `dart format --set-exit-if-changed`؛ تست‌های واحد `kaka_core`/`kaka_sms`/`kaka_i18n` (golden برای فرمت اعداد و RTL)؛ بررسی schema برای `catalog.v1.json` و `kaka_tools`؛ build APK (debug روی PR، release امضاشده روی tag) + انتشار در GitHub Releases؛ build باینری `kaka-mcp` برای ۳ سیستم‌عامل؛ (اختیاری) eval فارسی روی Ollama.
- فایل‌ها: `CONTRIBUTING.md`، `SECURITY.md`، `CODE_OF_CONDUCT.md`، issue templates (بانک جدید، مدل جدید)، `docs/adr/` برای تصمیم‌ها.
- توزیع: GitHub Releases + F-Droid (مناسب متن‌باز)؛ بعداً Play/بازار/مایکت (رایگان).

## 14. ریسک‌ها
1. **Google APIs از ایران** (Sheets، Sign-In) احتمالاً مسدود ⇐ Sheets اختیاری، پشتیبان فایل همیشه کار می‌کند.
2. **Hugging Face فیلتر** ⇐ mirror GitHub Releases (که خودش ممکن است کند باشد) + افزودن فایل دستی.
3. **کیفیت فارسی مدل‌های کوچک** پایین و گوشی‌های متوسط ضعیف ⇐ eval قبل از پیشنهاد؛ AI اختیاری.
4. **منبع رایگان نرخ بازار آزاد ایران** پایدار/قانونی وجود ندارد شاید ⇐ ورود دستی پیش‌فرض.
5. **از دست رفتن داده** بدون سرور ⇐ یادآور پشتیبان.
6. **AppFunctions** زمان‌بندی نامعلوم؛ اپ‌های موبایل AI به MCP محلی وصل نمی‌شوند.
7. **پیچیدگی چندارزی و scale** ⇐ تست‌های property-based برای تراز و تبدیل.
8. **سیاست Play دربارهٔ SMS** ⇐ در MVP فقط Share.
9. **لایسنس مدل‌ها** برای mirror کردن وزن‌ها.

## 15. سؤال‌های باز
- ✅ O1 (حل‌شده): لایسنس = **MIT**.
- O2: نام/سازمان GitHub و اسم انگلیسی (Kaka)؟
- ✅ O3 (حل‌شده): ارزهای اولیه = IRR، IRT (واحد نمایشی ریال)، USD، EUR، AED؛ GBP/TRY حذف، فهرست قابل گسترش. (باز: پیش‌فرض اعشار نمایش ریال/تومان = ۰؟)
- ✅ O3b (حل‌شده): طلا و سکه ارز نیستند ⇐ دارایی (`asset_holdings`) با ارزش‌گذاری قیمت روز/آخرین قیمت یا قیمت دستی (بخش 3.3).
- O4: تومان به‌عنوان واحد نمایشی (پیشنهاد این سند) قبول است؟
- O5: ✅ ملی، ملت، صادرات، تجارت، پاسارگاد (قالب‌ها نیازمند نمونهٔ واقعی؛ §9.1)
- O6: Sheets در v0.3 یا زودتر؟
- O7: منبع نرخ پیش‌فرض بعد از تأیید (spike).
- O8: دو مدل پیش‌فرض catalog بعد از benchmark روی گوشی واقعی.

## 16. Spikeها
1. SQLCipher با Drift روی Flutter فعلی. 2. `flutter_gemma` با Gemma 4 E2B روی گوشی میان‌رده + tool calling فارسی. 3. binding llama.cpp برای Flutter. 4. Sheets API با `drive.file` از ایران (با/بدون VPN). 5. منابع نرخ. 6. نوشتن در Sheets از ChatGPT/Claude connectors.
