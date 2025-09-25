# KraftDo Base Image

Imagen base Docker reutilizable para proyectos Laravel/PHP con Nginx, optimizada para aplicaciones web de alto rendimiento.

## 🚀 Características

- **PHP 8.3** con FPM
- **Nginx** optimizado para Laravel
- **Extensiones PHP** preinstaladas: PDO, MySQL, SQLite, GD, Redis, OPcache, etc.
- **Alpine Linux** para imágenes livianas
- **OPcache** configurado para producción
- **Configuraciones optimizadas** para aplicaciones web

## 📦 Uso

### Dockerfile básico

```dockerfile
FROM ghcr.io/buguenocesar92/kraftdo-base:latest

# Copiar tu aplicación
COPY --chown=nginx:nginx . /var/www/html/

# Personalizar configuraciones si es necesario
COPY docker/nginx/mi-app.conf /etc/nginx/conf.d/default.conf

# Entrypoint específico de tu proyecto
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
```

### Para proyectos Laravel

```dockerfile
FROM ghcr.io/buguenocesar92/kraftdo-base:latest

# Instalar dependencias con Composer
COPY composer.json composer.lock ./
RUN composer install --no-dev --optimize-autoloader

# Copiar aplicación
COPY --chown=nginx:nginx . ./

# Configurar permisos Laravel
RUN mkdir -p storage/logs storage/framework/{cache,sessions,views} bootstrap/cache && \
    chown -R nginx:nginx storage bootstrap/cache && \
    chmod -R 775 storage bootstrap/cache

# Entrypoint para Laravel
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
```

## 🏗️ Build local

```bash
git clone https://github.com/buguenocesar92/kraftdo-base.git
cd kraftdo-base
docker build -t kraftdo-base .
```

## 🔧 Personalización

### Configuraciones incluidas

- **PHP**: `/usr/local/etc/php/conf.d/custom.ini`
- **OPcache**: `/usr/local/etc/php/conf.d/opcache.ini` 
- **Nginx**: `/etc/nginx/nginx.conf`
- **PHP-FPM**: Pool configurado para nginx

### Variables de entorno comunes

```bash
# En tu docker-compose.yml o Dockerfile
environment:
  - PHP_MEMORY_LIMIT=512M
  - PHP_MAX_EXECUTION_TIME=300
  - NGINX_CLIENT_MAX_BODY_SIZE=100M
```

## 📁 Estructura

```
kraftdo-base/
├── Dockerfile              # Imagen principal
├── docker/
│   ├── php/
│   │   ├── php-base.ini    # Configuración PHP
│   │   └── opcache-base.ini # Configuración OPcache
│   ├── nginx/
│   │   └── nginx-base.conf # Configuración Nginx
│   └── php-fpm/
│       └── pool-base.conf  # Pool PHP-FPM
├── examples/               # Ejemplos de uso
└── .github/workflows/      # CI/CD
```

## 🏷️ Tags disponibles

- `latest` - Última versión estable
- `php8.3` - PHP 8.3 específico
- `develop` - Rama de desarrollo

## 📋 Extensiones PHP incluidas

- `pdo`, `pdo_mysql`, `pdo_sqlite`
- `gd`, `zip`, `mbstring`
- `curl`, `opcache`, `intl`
- `sockets`, `bcmath`, `exif`
- `redis`

## 🔒 Seguridad

- Imagen escaneada automáticamente con Trivy
- Actualizaciones semanales automáticas
- Configuraciones de seguridad aplicadas
- Usuario no-root (nginx)

## 🤝 Contribuir

1. Fork el repositorio
2. Crear rama para tu feature (`git checkout -b feature/nueva-caracteristica`)
3. Commit tus cambios (`git commit -am 'Agregar nueva característica'`)
4. Push a la rama (`git push origin feature/nueva-caracteristica`)
5. Crear Pull Request

## 📄 Licencia

MIT License - ver archivo [LICENSE](LICENSE) para detalles.

## 🔗 Proyectos relacionados

- [kraftdo-cms](https://github.com/buguenocesar92/kraftdo-cms) - Sistema CMS
- [kraftdo-nfc](https://github.com/buguenocesar92/kraftdo-nfc) - Sistema NFC

---

**Mantenido por**: [@buguenocesar92](https://github.com/buguenocesar92)