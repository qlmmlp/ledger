FROM php:8.2-fpm AS base

# Install system dependencies and PHP extensions in a single layer
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libpq-dev \
    zip \
    unzip \
    && docker-php-ext-install pdo_pgsql pgsql mbstring exif pcntl bcmath gd \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Use PHP-FPM's built-in user
RUN usermod -u 1000 www-data && \
    groupmod -g 1000 www-data

WORKDIR /app

# Development stage
FROM base AS dev
COPY docker/php/config/php.ini /usr/local/etc/php/conf.d/php.ini

# Install and configure Xdebug
RUN pecl install xdebug && \
    docker-php-ext-enable xdebug
COPY docker/php/config/xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

USER www-data

# Production stage
FROM base AS prod
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# Copy application files only in production
COPY --chown=www-data:www-data ./ /app

USER www-data