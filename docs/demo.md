# Recorrido de la demo

## 1. YAML: cambio aprobado y sincronización manual

Estado inicial: Application `web-plain`, una réplica y Welcome to nginx. Fuente: `apps/plain/web` en main. Auto-sync está desactivado para poder explicar el diff antes de sincronizar.

```sh
./demo/prepare-v2.sh
git diff -- apps/plain/web
git add apps/plain/web
git commit -m "Show GitOps web and scale to two replicas"
git push origin main
```

En Argo CD: Refresh si queremos adelantar la comprobación, mostrar OutOfSync y el diff, y después Sync. La página muestra la foto con etiquetas HTML y el nombre del Pod que atendió la solicitud. La réplica y la anotación de versión de contenido cambian en el Deployment para provocar un rollout que regenere el HTML. La imagen de Nginx permanece igual.

Las conexiones pueden seguir llegando al mismo Pod al recargar. Tener dos réplicas no garantiza alternancia en cada petición.

Para repetir el ensayo, `./demo/reset-v1.sh` prepara la restauración de los archivos; luego hay que hacer commit, push y sincronizar. Estos scripts no publican ni aplican cambios automáticamente.

## 2. Helm: crear una Application desde cero

No registrar ni sincronizar `web-helm` antes de la charla. Fuente: `apps/helm/gitops-web`, destino `helm-demo`. El namespace debe estar ausente inicialmente. En la UI marcar Auto-create namespace (CreateNamespace=true) y Server-side apply.

El chart crea dos ConfigMaps, Deployment, Service, Ingress, ServiceAccount y PodDisruptionBudget. Usamos el mismo sitio para centrarnos en la diferencia de empaquetado. No requiere credenciales de registry: la imagen es pública.

La Application declarativa de referencia está en `argocd/applications/web-helm.yaml`. Si la usamos, aplicamos únicamente ese archivo; no todo el directorio de Applications.

## Imagen

La foto proporcionada se conserva sin editar. Los rótulos Argo CD, Git y Kubernetes son elementos HTML sobre la foto. El archivo binario se monta desde un ConfigMap; ServerSideApply evita el tamaño de la anotación de client-side apply para este recurso. El nombre del Pod se incorpora al arrancar usando Downward API y envsubst del entrypoint oficial de Nginx.
