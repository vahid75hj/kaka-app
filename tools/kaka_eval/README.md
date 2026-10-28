# kaka-eval

Persian tool-calling eval for the AI backends Kaka can use (Ollama or any OpenAI-compatible endpoint).
31 cases (`data/fa_v1.json`): adding expenses/income/transfers from colloquial Persian (toman vs rial,
«۸۵ تومن» = 85 thousand toman), reading balances, spending, budgets, search, and questions that must
**not** create drafts. Each case runs against a fresh in-memory ledger through the real tools, with the
same system prompt as the app (`KakaPrompt`).

```sh
cd tools/kaka_eval
dart run kaka_eval --base-url http://localhost:11434/v1 --model qwen2.5:3b --out report.json
KAKA_EVAL_API_KEY=... dart run kaka_eval --base-url https://api.example.com/v1 --model some-model
```

Exit code is 0 only when every case passes. CI recipe: `docs/ci/eval.yml` (manual, Ollama on CPU).
