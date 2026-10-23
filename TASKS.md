# Kaka — task backlog

Source of truth for scope: [`docs/architecture-v4.md`](docs/architecture-v4.md) (Persian).
Phases: **MVP-1** = first usable APK · **MVP-2** = v0.1 feature-complete · **Later** = v0.2+.

## MVP-1 — usable vertical slice (now)

### Foundation
- [x] Monorepo with Dart pub workspaces (+ Melos scripts)
- [x] `kaka_domain`: `Money` (integer minor units), `Currency` (IRR, USD, EUR, AED), `DisplayUnit` (IRT = toman display unit of rial)
- [x] `kaka_domain`: double-entry ledger — accounts, postings, per-currency balance rule, factories for income / expense / transfer / opening balance, void (never delete)
- [x] `kaka_domain`: `AmountParser` (Persian/Arabic/Latin digits, separators) and `MoneyFormatter` (digits, separators, display decimals, rounding on display only)
- [x] `kaka_data`: Drift on SQLite3MultipleCiphers, key in Android Keystore (flutter_secure_storage); refuses to run without the cipher build
- [x] `kaka_data`: account / transaction / settings repositories, atomic transaction + postings writes
- [x] Unit tests: Money, toman display, parser, posting balance, ledger service, encrypted DB (wrong key fails)

### App (`apps/kaka_mobile`)
- [x] Riverpod state, go_router navigation, gen-l10n fa + en with RTL/LTR
- [x] Theme via `ThemeExtension` (`KakaColors`): light/dark/system × monochrome (default), orange, lime, blue; Vazirmatn font
- [x] Onboarding: language → calendar & digits (live preview) → base currency & decimals → first account
- [x] Home: net worth in base currency, other currencies listed separately, this-month income/expense, accounts strip, recent transactions
- [x] Accounts: create (with opening balance, any currency), rename, archive/restore
- [x] Add transaction: expense / income / transfer, category chips, date, note
- [x] Transactions list; long-press to void (kept crossed-out in history)
- [x] Settings: theme, accent, language, calendar, digits, base currency, decimals
- [x] Widget test: Persian onboarding → toman account on home

### Repo
- [x] MIT `LICENSE`, bilingual `README.md`, this `TASKS.md`
- [x] GitHub Actions: format, analyze, test, build APK artifact

### Shared packages (scaffolded early so the shape is fixed)
- [x] `kaka_tools`: tool catalog (`list_accounts`, `get_balance`, `list_transactions`, `summarize_spending`, `add_transaction` as draft-only) + `ToolRunner` + generated `schema/tools.v1.json`
- [x] `kaka_sms`: declarative parser engine + `sms-parsers.v1.json` (Melli, Mellat, Saderat, Tejarat, Pasargad as `needs_samples`)
- [x] `kaka_ai`: `AiProvider`, `OpenAiCompatProvider` (+ Ollama), `NoAiProvider`, on-device runtime contract, model catalog with merge, on-device tool loop

## MVP-2 — v0.1 complete
- [x] App lock (device biometric / PIN via `local_auth`, opt-in so nobody is locked out; 30 s grace) — `FLAG_SECURE` still open
- [x] Jalali date picker (Saturday-first grid; Material picker for Gregorian)
- [x] Category management screen (add / rename / archive across currencies) — custom icons still open
- [x] Question queue (`drafts` table, schema v2) for drafts from SMS / share / paste; confirm-by-review, discard, dedup key
- [x] Share-in (`ACTION_SEND`, `ACTION_PROCESS_TEXT`) + paste SMS → SMS parser → question queue
- [~] SMS templates for the 5 banks: best-effort public-format templates + sample tests shipped as `needs_samples`; **verify with masked real samples**. "Learn a new bank" flow still open
- [ ] CI step that runs every catalog entry's `tests`
- [x] Encrypted `.kaka` backup (Argon2id m=19 MiB t=2 + XChaCha20-Poly1305, header as AAD) via share sheet; restore via file picker — reminder still open
- [ ] Exchange rates (manual first, one public source after spike) and cross-currency transfers via `FX:<cur>` accounts
- [ ] Net worth converted to base currency with rate date / "stale" label
- [ ] Gold & coins as assets (`asset_holdings`), valued by manual / latest price
- [ ] Monthly report by category; Share-out CSV / summary + ready-made prompt
- [ ] BYO-AI settings screen (OpenAI-compatible key in secure storage, Ollama URL, none) + chat tab using `ToolLoop` + card/IBAN masking
- [x] Transaction search & filters (text, kind, account, date range) — edit-by-void-and-replace still open
- [~] Release signing (dedicated release key via `android/key.properties`, falls back to debug) + split-per-ABI APKs on GitHub Releases — CI signing on tags and F-Droid metadata still open
- [ ] `CONTRIBUTING.md` (add a bank / model / language), `SECURITY.md`, issue templates

## Later (v0.2+)
- [ ] On-device models: `flutter_gemma` runtime, download with mirrors + sha256, device fit check, probe
- [ ] Fill `model_catalog/catalog.v1.json` after on-device benchmark
- [ ] `tools/kaka_mcp`: desktop MCP server (stdio) reading `.kaka` backups
- [ ] Google Sheets mirror + Inbox tab (`drive.file`), `kaka-mcp --sheet`
- [ ] Persian eval set + CI eval on Ollama
- [ ] llama.cpp (GGUF) runtime, Android AppFunctions, iOS/desktop, budgets, CSV/Excel import, LAN/QR transfer

## Spikes / open questions
- [ ] Sheets API reachability from Iran (with/without VPN)
- [ ] Free, stable rate sources (international + Iranian open market)
- [ ] Do ChatGPT/Claude connectors support writing to Sheets?
