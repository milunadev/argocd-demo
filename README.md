# Argo CD demo

Laboratorio de la charla **De kubectl a GitOps**.

- `bootstrap/argocd/`: chart y valores Helm de instalación.
- `apps/plain/`: aplicaciones con YAML.
- `apps/helm/`: aplicaciones con Helm.
- `argocd/applications/`: Applications de Argo CD.
- `docs/`: notas de estudio.

```sh
KUBE_CONTEXT=<contexto> ./bootstrap/argocd/install.sh
```

El ejemplo usa Ingress nginx, Service ClusterIP y certificado autofirmado de laboratorio.
Puedes adaptar `bootstrap/argocd/values.local.yaml` (excluido de Git).
Los parámetros y credenciales del entorno local no se publican.

Demo: [recorrido y comandos](docs/demo.md).
