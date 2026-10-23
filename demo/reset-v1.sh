#!/usr/bin/env bash
set -euo pipefail
root_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cp "$root_dir/demo/v1/deployment.yaml" "$root_dir/apps/plain/web/deployment.yaml"
printf 'v1 preparada. Revisa git diff, haz commit y push, y sincroniza desde Argo CD.\n'
