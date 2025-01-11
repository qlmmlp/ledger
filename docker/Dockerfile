# syntax=docker/dockerfile:1

# Base stage
FROM php:8.2-fpm AS base

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libpq-dev \
    zip \
    unzip \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_pgsql pgsql mbstring exif pcntl bcmath gd

# Copy base configuration
COPY docker/config/php.ini /usr/local/etc/php/conf.d/app.ini

# Get Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Create system user
RUN useradd -G www-data,root -u 1000 -d /home/dev dev
RUN mkdir -p /home/dev/.composer && \
    chown -R dev:dev /home/dev

# Set working directory
WORKDIR /var/www

# Development stage
FROM base AS dev

# Install Xdebug
RUN pecl install xdebug && \
    docker-php-ext-enable xdebug

# Copy Xdebug configuration
COPY docker/config/xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini

USER dev

# Production stage
FROM base AS prod

# Add production optimizations
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

USER dev
