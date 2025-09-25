# =============================================================================
# EJEMPLO: Dockerfile para proyecto Laravel usando kraftdo-base
# =============================================================================

# Etapa 1: Build de assets (si aplica)
FROM node:20-alpine AS assets-build
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production
COPY resources/ ./resources/
COPY vite.config.js tailwind.config.js postcss.config.js ./
RUN npm run build

# Etapa 2: Build de dependencias PHP
FROM composer:2 AS php-deps
WORKDIR /app
COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Etapa 3: Imagen final usando kraftdo-base
FROM ghcr.io/buguenocesar92/kraftdo-base:latest

# Copiar dependencias PHP
COPY --from=php-deps /app/vendor ./vendor

# Copiar aplicación Laravel
COPY --chown=nginx:nginx . ./

# Copiar assets compilados (si aplica)
COPY --from=assets-build --chown=nginx:nginx /app/public/build ./public/build

# Crear directorios Laravel y permisos
RUN mkdir -p storage/logs storage/framework/{cache,sessions,views} bootstrap/cache && \
    chown -R nginx:nginx storage bootstrap/cache && \
    chmod -R 775 storage bootstrap/cache

# Entrypoint personalizado
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]