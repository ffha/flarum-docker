FROM php:8.1-apache
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
RUN a2enmod rewrite
RUN rm -rf /etc/apt/preferences.d/*
RUN apt-get update
RUN apt-get install git unzip -y
RUN apt-get update && apt-get install -y \
		libfreetype6-dev \
		libjpeg62-turbo-dev \
		libpng-dev \
	&& docker-php-ext-configure gd --with-freetype --with-jpeg \
	&& docker-php-ext-install -j$(nproc) gd
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install mysqli
COPY --from=composer /usr/bin/composer /usr/bin/composer
WORKDIR /var/www/html
RUN chmod -R 755 /var/www/html
USER www-data
RUN composer create-project flarum/flarum .
RUN composer require flarum-lang/chinese-simplified
USER root
