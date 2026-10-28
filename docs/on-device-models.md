# On-device models: status and plan

## Done (v0.5.0)
- `model_catalog/catalog.v1.json` lists three open (ungated) models: Qwen3 0.6B int4, Qwen3 0.6B mixed-int4 and
  Qwen2.5 1.5B q8. Their sizes and SHA-256s come from Hugging Face's LFS metadata. Each has a Hugging Face URL plus
  the `hf-mirror.com` mirror.
- `ModelDownloader` (in `kaka_ai`):
  - tries the primary URL, then each mirror
  - resumes partial downloads with HTTP Range
  - verifies SHA-256 and never keeps a file that fails the check
- `ModelFit.check` compares a model against the device's RAM, Android API level, CPU ABI and free disk space.

## Not done: runtime adapter
`flutter_gemma` has been renamed to **`flutter_edge_ai`** (2.5.x, with engines as separate packages):
- `flutter_edge_ai_litertlm` runs `.litertlm` files and needs **minSdk 30 and arm64-v8a only**.
- `flutter_edge_ai_mediapipe` runs `.task` files on more ABIs, but upstream only maintains it now.

Kaka supports minSdk 24 (Android 7+), and many users in Iran have older or 32-bit phones. The plugin registers at app
start on every device, so adding it blind risks crashes at launch on unsupported devices. We can't test that without
hardware. Next steps:
1. On a real arm64 phone and a 32-bit phone, check whether `tools:overrideLibrary` plus a Dart-side guard
   (`androidSdk >= 30 && abis.contains('arm64-v8a')`) keeps unsupported devices safe. Otherwise ship a separate
   `kaka-ai` APK flavor.
2. Implement `LocalModelRuntime` → `AiProvider` with `flutter_edge_ai` (`installModel(...).fromFile(path)` using the
   file `ModelDownloader` verified), and map Kaka tools onto its function calling.
3. Benchmark Persian quality, function-call accuracy and tokens/s on a 4 GB and an 8 GB phone, then set the `tier`
   and `min_ram_mb` values from the measurements.
