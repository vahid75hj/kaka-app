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
- [x] SMS parser rework (v0.3.0): normalization (ك/ي, bidi marks, `*`), verified templates from real samples (Melli, Saderat, Tejarat, **Mehr Iran**), heuristic fallback with confidence, MMDD dates with year inferred from receive time — Mellat/Pasargad still `needs_samples`
- [x] Opt-in automatic SMS reading (READ_SMS/RECEIVE_SMS asked only when enabled): 30-day first scan, incremental scan on resume, live receiver while the app runs; off = no reading, receiver stopped
- [x] Sender ↔ account linking (sender default account + account-number links, suffix and dashed-form matching); only linked senders are read
- [x] Bank balance vs ledger mismatch hint on drafts
- [x] Background SMS when the app is closed (opt-in): manifest receiver disabled by default, app-private pending queue, WorkManager → headless Dart `smsBackgroundMain` → drafts + notification; app drains leftovers on open — untested on a device
- [x] "Learn a new bank" flow (diff 3–5 samples into a template)
- [~] CI workflow written (`docs/ci/ci.yml`: format, analyze, package + catalog tests, app tests) — must be moved into `.github/workflows/` with a `workflow`-scoped token; old template workflows still fail
- [x] Encrypted `.kaka` backup (Argon2id m=19 MiB t=2 + XChaCha20-Poly1305, header as AAD) via share sheet; restore via file picker + backup reminder (home card, every 7/14/30 days or off, last backup date)
- [x] Exchange rates (manual, per date) and cross-currency exchange via `FX:<cur>` accounts — public rate source still open
- [x] Net worth converted to base currency with rate date / "stale" label
- [x] Gold & coins as assets (`asset_holdings`), valued by manual / latest price
- [x] Monthly report by category; Share-out CSV / summary + ready-made prompt
- [x] BYO-AI settings screen (OpenAI-compatible key in secure storage, Ollama URL, none) + chat tab using `ToolLoop` + card/IBAN masking
- [x] Edit transaction (void-and-replace), FLAG_SECURE toggle — v0.4.0
- [x] Asset buy/sell can pay from / receive into an account (`asset` kind via `Assets:<cur>`), history + void together (schema v5)
- [x] AI transfer drafts: real from → to transfer drafts + suggested category (drafts v5 columns), tool validates target / currency / system accounts
- [x] Transaction search & filters (text, kind, account, date range) — edit-by-void-and-replace still open
- [~] Release signing (dedicated release key via `android/key.properties`, falls back to debug) + split-per-ABI APKs on GitHub Releases — CI signing on tags and F-Droid metadata still open
- [x] `CONTRIBUTING.md` (add a bank / model / language), `SECURITY.md`, issue templates

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
