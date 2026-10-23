# Argo CD demo

Laboratorio de la charla **De kubectl a GitOps**.

- `bootstrap/argocd/`: instalación de Argo CD con Helm.
- `apps/plain/web/`: Nginx inicial, una réplica, `superapp.test`.
- `images/gitops-web/`: imagen del perrito, `milunadev/gitops-web:v2`.
- `apps/helm/grafana/`: chart [Grafana Community](https://grafana.com/docs/grafana/latest/setup-grafana/installation/helm/) 14.0.1, Grafana 13.2.4; configuración en `values.demo.yaml`, acceso por `helm-app.test`.
- `argocd/applications/`: Applications de referencia.

## Cambio en vivo

```sh
./demo/prepare-v2.sh
git diff -- apps/plain/web
git add apps/plain/web
git commit -m "Deploy GitOps web v2 and scale to two replicas"
git push origin main
```

En Argo CD: Refresh → diff → Sync. Cambian la imagen y las réplicas; el sitio muestra el nombre real del Pod. Para repetir: `./demo/reset-v1.sh`, commit, push y Sync.

## Demo Helm

En Argo CD: NEW APP → EDIT AS YAML y pegar `argocd/applications/grafana.yaml`. Apunta a `apps/helm/grafana`, usa `values.demo.yaml` y crea el namespace `helm-demo` al sincronizar. La Application incluye las excepciones necesarias para la contraseña aleatoria del chart. El namespace queda sin crear antes de la demo.

El chart despliega Grafana, un sidecar para dashboards, ConfigMaps, Secret, Service, Ingress y RBAC limitado al namespace. Incluye un dashboard de bienvenida; no instala Prometheus. Los datos son efímeros en este laboratorio. El chart genera un password de admin; se preserva durante las sincronizaciones mediante ignoreDifferences.

```sh
kubectl -n helm-demo get secret grafana-demo -o jsonpath='{.data.admin-password}' | base64 --decode
```

## Construir la imagen

```sh
docker build --platform linux/amd64 -t milunadev/gitops-web:v2 images/gitops-web
docker push milunadev/gitops-web:v2
```

Configurar ambos dominios con la IP de tu Ingress controller. La configuración privada queda en `.local/` y `values.local.yaml`, excluidos de Git. Solo hay un README general; el chart de Grafana conserva sus plantillas y licencia upstream.
