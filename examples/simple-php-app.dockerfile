# =============================================================================
# EJEMPLO: Dockerfile para aplicación PHP simple usando kraftdo-base
# =============================================================================

FROM ghcr.io/buguenocesar92/kraftdo-base:latest

# Copiar aplicación PHP
COPY --chown=nginx:nginx src/ /var/www/html/

# Configuración personalizada si es necesaria
COPY nginx-custom.conf /etc/nginx/conf.d/default.conf

# Script de inicio simple
RUN echo '#!/bin/bash' > /entrypoint.sh && \
    echo 'nginx -g "daemon off;" &' >> /entrypoint.sh && \
    echo 'php-fpm' >> /entrypoint.sh && \
    chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]