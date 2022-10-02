FROM php:apache
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
RUN apt-get update
RUN apt-get install git unzip libfreetype6-dev libjpeg62-turbo-dev libpng-dev -y
RUN docker-php-ext-configure gd --with-freetype --with-jpeg 
RUN docker-php-ext-install -j$(nproc) gd
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install mysqli
COPY --from=composer /usr/bin/composer /usr/bin/composer
WORKDIR /app
ENV APACHE_DOCUMENT_ROOT /app/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
RUN chmod -R 755 /app
USER www-data
RUN composer create-project flarum/flarum .
RUN composer require flarum-lang/chinese-simplified
USER root
