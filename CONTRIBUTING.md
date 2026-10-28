# Contributing to Kaka / مشارکت در کاکا

Kaka is offline-first and privacy-first. Contributions must not add network calls, analytics or
trackers. The only optional network use is the user's own AI endpoint.

## Setup

```sh
flutter pub get                       # pub workspace: all packages at once
dart format --set-exit-if-changed .   # page width 120 (analysis_options)
dart analyze --fatal-infos
(cd packages/kaka_sms && dart test)   # likewise for every package with test/
(cd apps/kaka_mobile && flutter test)
```

CI runs exactly these. The workflow is in `docs/ci/ci.yml`. Move it to `.github/workflows/` (which needs a token with `workflow` scope) to replace the old template workflows.

## Layout (Clean Architecture)

| Package | Role |
|---|---|
| `kaka_domain` | Pure Dart entities, money (integer minor units), ledger rules, FX, assets, reports |
| `kaka_data` | Drift/SQLite3MultipleCiphers repositories, migrations, encrypted backup |
| `kaka_sms` | SMS normalization, bank template catalog, heuristic parser, template learner |
| `kaka_tools` | Tool schema for AI (`add_transaction` only creates drafts), masking |
| `kaka_ai` | OpenAI-compatible / Ollama clients and the tool loop |
| `apps/kaka_mobile` | Flutter UI (Riverpod, go_router, gen-l10n fa/en) |

Dependencies point inward: UI → data/sms/ai → domain. The domain imports no Flutter.

## Adding a bank / افزودن بانک

1. Collect 3–5 **real** SMS, then **mask** them: replace digits of account and card numbers except the
   last 4, and remove names. Never post unmasked SMS.
2. Add an entry to `packages/kaka_sms/assets/sms-parsers.v1.json`, with a regex that uses named groups
   (`(?<amount>…)`, `(?<direction>…)`, `(?<balance>…)`, `(?<account>…)`, `(?<date>…)`) and a `tests` array
   holding each sample and its expected fields. Bump `catalog_version`.
3. Use `status: verified` only when the entry is built from real samples. Otherwise use `needs_samples`.
4. Run `dart test` in `packages/kaka_sms`. It runs every catalog test.

Tip: the in-app "Learn a new bank" screen produces the same JSON. Copy a learned template as a
starting point.

## Adding a model

Edit `model_catalog/catalog.v1.json` with a download URL, mirrors, `sha256`, size and minimum RAM. Only
add a model after you have benchmarked it on a real device with the Persian eval set.

## Adding a language

Copy `apps/kaka_mobile/lib/l10n/app_en.arb` to `app_<code>.arb`, translate it, and run `flutter gen-l10n`.
Check the layout in both RTL and LTR.

## Database changes

Bump `schemaVersion` in `kaka_data` and add an `if (from < N)` step. Then add a migration test that
opens a database at the previous version and upgrades it. A backup made by an older version must
still restore.

## Commits

Use short conventional commits (`feat(sms): …`, `fix(app): …`). License: MIT. By contributing, you agree
that your work is licensed under MIT.
