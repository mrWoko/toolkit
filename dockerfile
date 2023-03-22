# Use a specific version of PHP
FROM php:8.0-fpm

# Set the working directory to /var/www/html
WORKDIR /var/www/html

# Install dependencies
RUN apt-get update && \
    apt-get install -y \
        git \
        libzip-dev \
        unzip \
        libpng-dev \
        && docker-php-ext-install pdo_mysql zip gd

# Install Node.js and npm
RUN apt-get install -y nodejs npm

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy the source code to the container
COPY . .

# Copy environment variables
COPY ./path/to/env/file /usr/local/etc/env_file

# Load environment variables
RUN echo "source /usr/local/etc/env_file" >> ~/.bashrc

# Install project dependencies
RUN composer install --no-dev

# Set permissions for Laravel
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache

# Copy custom php.ini file
COPY php.ini /usr/local/etc/php/

# Add health checks
HEALTHCHECK --interval=5s --timeout=3s \
    CMD curl -f http://localhost:9000 || exit 1

# Expose port 9000 and start php-fpm server
EXPOSE 9000
CMD ["php-fpm"]