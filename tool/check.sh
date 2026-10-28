#!/usr/bin/env bash
# Everything CI runs, failing on the first problem: ./tool/check.sh
set -euo pipefail
cd "$(dirname "$0")/.."
dart format --set-exit-if-changed . >/dev/null
dart analyze --fatal-infos
for p in packages/kaka_domain packages/kaka_data packages/kaka_sms packages/kaka_ai packages/kaka_tools tools/kaka_mcp; do
  (cd "$p" && dart test -r failures-only)
done
(cd apps/kaka_mobile && flutter test -r failures-only)
echo "all checks passed"
