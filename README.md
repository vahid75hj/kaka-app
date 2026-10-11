# kaka

Empty Serverpod fullstack project (`kaka_server`, `kaka_client`, `kaka_flutter`).

## Versions

| Tool | Version | Notes |
|------|---------|--------|
| **Serverpod** | **4.0.4** | Latest stable at project creation |
| **Flutter** | **3.47.0** | Via puro environment `env_3_44_9` |
| **Dart** | **3.13.0** | Bundled with the Flutter SDK above |

This project pins Flutter through puro (see `.puro.json`). It does **not** change your globally activated `serverpod_cli` (keep using your other project's global version as-is).

### Using Serverpod CLI for this project only

Activate/run Serverpod **4.0.4** with a separate pub cache so the global CLI stays untouched:

```bash
export PUB_CACHE="$HOME/.pub-cache-serverpod-4"
puro -e env_3_44_9 dart pub global activate serverpod_cli 4.0.4
puro -e env_3_44_9 dart pub global run serverpod_cli:serverpod_cli --version
```

Or, from `kaka_server` after the cache is activated:

```bash
export PUB_CACHE="$HOME/.pub-cache-serverpod-4"
export PATH="/Users/vahid/.puro/envs/env_3_44_9/flutter/bin:$PATH"
serverpod generate
serverpod start
```

## Setup

```bash
# Use the pinned Flutter environment
puro use env_3_44_9

# Install dependencies (from repo root)
flutter pub get

# Start Postgres (Docker) for development
cd kaka_server && docker compose up -d

# Generate / start (with Serverpod 4.0.4 via the isolated PUB_CACHE above)
serverpod generate
serverpod start
```

## Project layout

- `kaka_server` — Serverpod backend
- `kaka_client` — generated Dart client
- `kaka_flutter` — Flutter companion app
