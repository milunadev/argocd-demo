#!/usr/bin/env bash
set -euo pipefail
root_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
cp "$root_dir/demo/v2/configmap.yaml" "$root_dir/apps/plain/web/configmap.yaml"
cp "$root_dir/demo/v2/deployment.yaml" "$root_dir/apps/plain/web/deployment.yaml"
printf 'Cambio v2 preparado: contenido nuevo y dos réplicas. Revisa git diff antes de hacer commit y push.\n'
