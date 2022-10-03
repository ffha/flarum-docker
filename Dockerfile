FROM php:apache
RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
RUN sed -i 's|security.debian.org/debian-security|mirrors.ustc.edu.cn/debian-security|g' /etc/apt/sources.list
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"
RUN apt-get update
RUN apt-get install git unzip libfreetype6-dev libjpeg62-turbo-dev libpng-dev -y
RUN docker-php-ext-configure gd --with-freetype --with-jpeg 
RUN docker-php-ext-install -j$(nproc) gd
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install mysqli
RUN apt-get remove -y libfreetype6-dev libjpeg62-turbo-dev libpng-dev
COPY --from=composer /usr/bin/composer /usr/bin/composer
RUN composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/
WORKDIR /app
ENV APACHE_DOCUMENT_ROOT /app/public
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
RUN chmod 775 -R /app
RUN composer create-project flarum/flarum .
RUN composer require flarum-lang/chinese-simplified

