FROM php:8.1-apache
COPY --from=composer /usr/bin/composer /usr/bin/composer
RUN mkdir /app
WORKDIR /app
ENV APACHE_DOCUMENT_ROOT /app/public
RUN chmod -R 755 /app
RUN chown -R www-data:www-data /app
RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf
USER www-data
RUN composer create-project flarum/flarum .
RUN composer require flarum-lang/chinese-simplified
RUN php flarum cache:clear
USER root
