# Notas de estudio de Argo CD

Estas notas son para preparar la charla, no para copiarlas completas a una diapositiva.

## Comparación equilibrada con Flux

Ambos usan recursos personalizados de Kubernetes y controladores. La diferencia no es «Argo tiene UI y Flux tiene recursos»: Argo también se configura con Applications, AppProjects y ApplicationSets.

Una flota multiclúster puede tener controladores distribuidos por clúster o un controlador que gestiona destinos remotos. Multiclúster no implica una única instancia central.

En la arquitectura habitual Argo CD gestiona destinos remotos mediante la API de Kubernetes y credenciales registradas; no exige instalar un agente de Argo CD en cada destino. Hay otras arquitecturas e integraciones, pero no hacen falta en la introducción.

Flux separa responsabilidades en controladores de fuentes, Kustomize y Helm, entre otros. Argo CD reparte sus funciones principales entre API server, repository server y application controller.

## Pull, Refresh y Sync

Argo CD sigue un modelo de obtención de la configuración desde las fuentes (pull). Un git push hecho por una persona no convierte el despliegue en push-based.

- **Refresh**: vuelve a comparar la configuración deseada con la actual. No equivale a desplegar.
- **Hard Refresh**: invalida las cachés relevantes para regenerar la configuración deseada.
- **Sync**: solicita aplicar una revisión y sus recursos al destino. No debe definirse simplemente como «ir a buscar cambios».
- **Auto-sync**: permite aplicar automáticamente cambios detectados en la configuración deseada.
- **Self-heal**: permite corregir cambios directos del estado actual con sincronización automática configurada.

Por defecto existe una comprobación periódica de las fuentes. En la documentación estable consultada, `timeout.reconciliation` vale 120s y `timeout.reconciliation.jitter` añade hasta 60s de variación. Son ajustes de versión/configuración; se comprobarán en nuestra instalación.

Un webhook puede provocar una comprobación antes de ese plazo. La notificación no sustituye al reconciliador ni convierte el modelo en un pipeline que empuja manifiestos.

Se puede desactivar el polling con `timeout.reconciliation: 0`, considerando también la configuración de caché. Eso no significa desactivar toda observación del clúster, ni es lo mismo que desactivar auto-sync. La documentación advierte que depender exclusivamente de webhooks puede perder comprobaciones si fallan las notificaciones.

## Flujo concreto: un chart almacenado en Git

1. Una Application define repositorio, revisión, ruta, parámetros, destino y política de sincronización.
2. El application controller solicita la configuración deseada al repository server durante el procesamiento de la aplicación.
3. El repository server mantiene una copia/caché del repositorio, obtiene la revisión requerida y prepara el contenido de la ruta.
4. Si esa ruta contiene un chart, el repository server ejecuta Helm para generar manifiestos con los valores configurados. `helm template` se ejecuta aquí, no en el navegador ni en los Pods de la aplicación.
5. El application controller obtiene el estado actual del destino mediante sus clientes de la API de Kubernetes y las cachés de observación. Compara ese estado con los manifiestos deseados y registra la diferencia.
6. El API server de Argo CD permite consultar esa información desde la interfaz o CLI y solicitar operaciones. No confundirlo con kube-apiserver.
7. Una sincronización manual o automática hace aplicar los recursos en la API de Kubernetes destino. Después los controladores nativos realizan su trabajo: por ejemplo, Deployment y ReplicaSet ajustan los Pods.
8. La observación continúa. Que la configuración esté Synced y que los recursos estén Healthy son evaluaciones distintas.

Si el chart está en un repositorio Helm u OCI en lugar de estar dentro de Git, cambia el origen de descarga. La responsabilidad de generar los manifiestos permanece en el repository server.

## Helm, Kustomize y Jsonnet

**Helm**: empaqueta recursos relacionados en un chart, normalmente con plantillas y valores. Con `helm install/upgrade`, Helm gestiona una release. Al desplegar una aplicación Helm mediante Argo CD, Argo usa Helm como generador de manifiestos y gestiona el ciclo de vida por su cuenta. Por eso esa aplicación no aparece como una release normal en `helm list`.

**Kustomize**: transforma manifiestos YAML existentes. Ejemplo: una base describe `web` con una réplica; la variante de producción cambia a tres y añade etiquetas. El resultado es un manifiesto completo listo para aplicar. No es necesario reemplazar el YAML base por plantillas con variables.

**Jsonnet**: lenguaje para generar configuración, con funciones, reutilización de objetos y otras construcciones. Puede generar datos JSON/YAML; Argo CD puede usarlo para producir manifiestos Kubernetes. No es necesario incluirlo en la demo inicial.

## Instalar Argo CD con Helm

En este paso sí utilizaremos Helm como gestor de la instalación de Argo CD: creará una release de Helm. El chart renderiza componentes, Services, RBAC, configuración y CRDs según los valores. Los componentes que arrancan después son los que realizarán la reconciliación GitOps.

La instalación del producto no equivale a definir la Application de nuestra web. Ese será el siguiente paso.

## Demo inicial propuesta

1. Application de una web con dos réplicas; primera sincronización manual.
2. Cambio de imagen en Git y observación del diff.
3. Sincronización automática para cambios aprobados en Git.
4. Cambio directo a nueve réplicas con self-heal desactivado; diferencia visible.
5. Activar la corrección automática y recuperar las dos réplicas declaradas.
6. Un ejemplo Helm posterior, separado del primero, si queda tiempo.

La infraestructura base del laboratorio no será gestionada por la Application de la demo.

## Referencias

- Arquitectura: https://argo-cd.readthedocs.io/en/stable/operator-manual/architecture/
- Polling y caché: https://argo-cd.readthedocs.io/en/stable/faq/#how-often-does-argo-cd-check-for-changes-to-my-git-or-helm-repository
- Configuración: https://argo-cd.readthedocs.io/en/stable/operator-manual/argocd-cm-yaml/
- Auto-sync y self-heal: https://argo-cd.readthedocs.io/en/stable/user-guide/auto_sync/
- Helm en Argo CD: https://argo-cd.readthedocs.io/en/stable/user-guide/helm/
- Helm charts: https://helm.sh/docs/topics/charts/
- Kustomize: https://kubernetes.io/docs/tasks/manage-kubernetes-objects/kustomization/
- Jsonnet: https://jsonnet.org/
- Flux: https://fluxcd.io/flux/
- Clúster remoto: https://argo-cd.readthedocs.io/en/stable/getting_started/#5-register-a-cluster-to-deploy-apps-to-optional
