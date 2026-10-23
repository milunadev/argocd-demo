#!/usr/bin/env bash
set -euo pipefail
root_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cp "$root_dir/demo/v1/configmap.yaml" "$root_dir/apps/plain/web/configmap.yaml"
cp "$root_dir/demo/v1/deployment.yaml" "$root_dir/apps/plain/web/deployment.yaml"
printf 'Archivos v1 restaurados. Revisa, haz commit y push, y sincroniza desde Argo CD.\n'
