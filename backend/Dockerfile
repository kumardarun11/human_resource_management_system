# ===========================
# Stage 1 - Composer
# ===========================
FROM composer:2 AS composer

WORKDIR /app

COPY composer.json composer.lock ./

RUN composer install \
    --prefer-dist \
    --no-interaction \
    --no-scripts

COPY . .

RUN composer dump-autoload --optimize

# ===========================
# Stage 2 - PHP-FPM
# ===========================
FROM php:8.2-fpm

RUN apt-get update && apt-get install -y \
    git \
    unzip \
    curl \
    zip \
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
       opcache

WORKDIR /var/www

COPY --from=composer /app /var/www

COPY docker/php/local.ini /usr/local/etc/php/conf.d/local.ini

COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

RUN chown -R www-data:www-data /var/www

EXPOSE 9000

ENTRYPOINT ["/entrypoint.sh"]

CMD ["php-fpm"]