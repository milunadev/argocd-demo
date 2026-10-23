#!/usr/bin/env bash
set -euo pipefail
: "${KUBE_CONTEXT:?Define KUBE_CONTEXT con el contexto de destino}"
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
values_file="$script_dir/values.demo.yaml"
if [[ -f "$script_dir/values.local.yaml" ]]; then
  values_file="$script_dir/values.local.yaml"
fi
helm upgrade --install argocd "$script_dir/upstream/argo-cd" \
  --kube-context "$KUBE_CONTEXT" \
  --namespace argocd \
  --create-namespace \
  --values "$values_file" \
  --wait --timeout 10m
