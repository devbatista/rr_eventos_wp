FROM php:8.2-fpm-alpine

RUN apk add --no-cache \
    bash \
    curl \
    icu-dev \
    libjpeg-turbo-dev \
    libpng-dev \
    libwebp-dev \
    libzip-dev \
    nginx \
    oniguruma-dev \
    supervisor \
    unzip \
    zip \
  && docker-php-ext-configure gd --with-jpeg --with-webp \
  && docker-php-ext-install -j"$(nproc)" \
    exif \
    gd \
    intl \
    mysqli \
    opcache \
    pdo_mysql \
    zip \
  && mkdir -p /usr/src/wordpress \
  && curl -fsSL https://wordpress.org/latest.tar.gz -o /tmp/wordpress.tar.gz \
  && tar -xzf /tmp/wordpress.tar.gz -C /tmp \
  && cp -R /tmp/wordpress/. /usr/src/wordpress/ \
  && cp -R /usr/src/wordpress/. /var/www/html/ \
  && rm -rf /tmp/wordpress /tmp/wordpress.tar.gz \
  && chown -R www-data:www-data /usr/src/wordpress /var/www/html \
  && mkdir -p /run/nginx /var/log/supervisor

COPY docker/php/uploads.ini /usr/local/etc/php/conf.d/uploads.ini
COPY docker/php-fpm/zz-www-pool.conf /usr/local/etc/php-fpm.d/zz-www-pool.conf
COPY nginx/ /etc/nginx/
COPY docker/supervisor/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY docker/entrypoint.sh /usr/local/bin/docker-entrypoint

RUN cp /etc/nginx/default.conf /etc/nginx/http.d/default.conf \
  && chmod +x /usr/local/bin/docker-entrypoint

WORKDIR /var/www/html/

EXPOSE 80

ENTRYPOINT ["docker-entrypoint"]
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
