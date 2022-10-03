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
WORKDIR /var/www/html
RUN chmod 775 -R /var/www/html
RUN chown www-data:www-data -R /var/www/html
RUN composer create-project flarum/flarum .
RUN composer require flarum-lang/chinese-simplified

