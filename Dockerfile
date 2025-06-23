# PHP 8.2 FPM
FROM php:8.2-fpm

# 
WORKDIR /var/www

# 
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    zip \
    unzip \
    git \
    curl \
    libonig-dev \
    netcat-openbsd \
    libpq-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd mbstring pdo pdo_pgsql opcache

# Composer 
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# 
COPY . /var/www

# 
RUN chown -R www-data:www-data /var/www

# Laravel storage  cache 
RUN chmod -R 775 /var/www/storage /var/www/bootstrap/cache

# entrypoint 
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Composer  PHP 
RUN composer install --no-dev --optimize-autoloader

# PHP-FPM 
EXPOSE 9000

# 
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]

# PHP-FPM 
CMD ["php-fpm"]

