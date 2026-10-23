FROM nginx:1.30.6-alpine
LABEL org.opencontainers.image.source="https://github.com/milunadev/argocd-demo"
ENV POD_NAME=local-docker \
    NGINX_ENVSUBST_OUTPUT_DIR=/usr/share/nginx/html \
    NGINX_ENVSUBST_FILTER=POD_NAME \
    NGINX_ENTRYPOINT_WORKER_PROCESSES_AUTOTUNE=1
COPY index.html.template /etc/nginx/templates/index.html.template
COPY assets/ /usr/share/nginx/html/assets/
