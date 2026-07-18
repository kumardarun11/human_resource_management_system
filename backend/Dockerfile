# ===========================
# Stage 1 - Composer
# ===========================
FROM composer:2 AS composer

WORKDIR /app

COPY composer.json composer.lock ./

RUN composer install \
    --prefer-dist \
    --no-dev \
    --optimize-autoloader \
    --no-interaction

COPY . .

# ===========================
# Stage 2 - Apache + PHP
# ===========================
FROM php:8.2-apache

RUN apt-get update && apt-get install -y \
    git \
    unzip \
    zip \
    curl \
    libzip-dev \
    libpng-dev \
    libjpeg62-turbo-dev \
    libfreetype6-dev \
    libonig-dev \
    libxml2-dev \
    && docker-php-ext-configure gd \
        --with-freetype \
        --with-jpeg \
    && docker-php-ext-install \
        pdo_mysql \
        mbstring \
        zip \
        exif \
        bcmath \
        gd \
        opcache \
    && a2enmod rewrite

WORKDIR /var/www/html

COPY --from=composer /app /var/www/html

COPY docker/php/local.ini /usr/local/etc/php/conf.d/local.ini

COPY docker/certs/ca.pem /var/www/docker/certs/ca.pem

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

# Laravel permissions
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 storage bootstrap/cache

# Apache DocumentRoot -> public
ENV APACHE_DOCUMENT_ROOT=/var/www/html/public

RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' \
    /etc/apache2/sites-available/*.conf \
    /etc/apache2/apache2.conf \
    /etc/apache2/conf-available/*.conf

EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]

CMD ["apache2-foreground"]