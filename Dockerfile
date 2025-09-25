# =============================================================================
# KRAFTDO BASE IMAGE - Imagen base reutilizable para proyectos Laravel/PHP
# =============================================================================
# Versión: PHP 8.3 + Nginx + Extensiones comunes
# Uso: FROM ghcr.io/buguenocesar92/kraftdo-base:latest

FROM php:8.3-fpm-alpine

LABEL maintainer="buguenocesar92"
LABEL description="Imagen base para proyectos KraftDo con PHP 8.3, Nginx y extensiones comunes"
LABEL version="1.0.0"

# Instalar dependencias del sistema
RUN apk update && apk add --no-cache \
    # Dependencias runtime
    sqlite \
    libpng \
    libjpeg-turbo \
    freetype \
    libzip \
    oniguruma \
    curl \
    icu \
    zip \
    unzip \
    git \
    bash \
    nginx

# Instalar dependencias de desarrollo (temporal)
RUN apk add --no-cache --virtual .build-deps \
    autoconf \
    dpkg-dev \
    dpkg \
    file \
    g++ \
    gcc \
    libc-dev \
    make \
    pkgconf \
    re2c \
    sqlite-dev \
    libpng-dev \
    libjpeg-turbo-dev \
    freetype-dev \
    libzip-dev \
    oniguruma-dev \
    curl-dev \
    icu-dev \
    linux-headers \
    zlib-dev

# Configurar e instalar extensiones PHP
RUN docker-php-ext-configure gd \
        --with-freetype=/usr/include/ \
        --with-jpeg=/usr/include/ \
    && docker-php-ext-install -j$(nproc) \
        pdo \
        pdo_mysql \
        pdo_sqlite \
        gd \
        zip \
        mbstring \
        curl \
        opcache \
        intl \
        sockets \
        bcmath \
        exif

# Instalar Redis (extensión crítica para Laravel)
RUN pecl install redis \
    && docker-php-ext-enable redis

# Limpiar dependencias de desarrollo para reducir tamaño
RUN apk del .build-deps \
    && rm -rf /var/cache/apk/* \
    && rm -rf /tmp/* \
    && rm -rf /var/tmp/*

# Copiar configuraciones base genéricas
COPY docker/php/opcache-base.ini /usr/local/etc/php/conf.d/opcache.ini
COPY docker/php/php-base.ini /usr/local/etc/php/conf.d/custom.ini
COPY docker/nginx/nginx-base.conf /etc/nginx/nginx.conf

# Crear directorios y usuarios necesarios
RUN mkdir -p /var/log/php /tmp/opcache /var/www/html && \
    # Crear usuario nginx si no existe
    addgroup -g 82 -S nginx 2>/dev/null || true && \
    adduser -u 82 -D -S -G nginx nginx 2>/dev/null || true && \
    # Establecer permisos
    chown nginx:nginx /var/log/php && \
    chmod 755 /tmp/opcache

# Establecer directorio de trabajo
WORKDIR /var/www/html

# Exponer puertos estándar
EXPOSE 80 9000

# No definir ENTRYPOINT - cada proyecto específico define el suyo
# Esta imagen base proporciona solo la infraestructura base