FROM php:8.1-fpm-ubuntu

RUN apt-get update && apt-get -y install curl

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp
RUN php -r "readfile('https://getcomposer.org/installer');" | php -- --install-dir=/usr/bin/ --filename=composer
RUN composer global require "squizlabs/php_codesniffer=*"
RUN composer global config allow-plugins.dealerdirect/phpcodesniffer-composer-installer true
RUN composer global require --dev wp-coding-standards/wpcs

RUN pecl install "xdebug-3.1.3" && docker-php-ext-enable xdebug
RUN echo "xdebug.mode=debug" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini && \
    echo "xdebug.client_host=host.docker.internal" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
