FROM php:8.1-cli

VOLUME [ "/app", "/root/.ssh" ]
WORKDIR /app

# install system deps
RUN apt-get update \
    && apt-get install -y libcurl4-openssl-dev pkg-config libssl-dev libpng-dev zlib1g-dev libicu-dev g++ libxml2-dev git zip wget ca-certificates libhiredis-dev supervisor libmpdec-dev sudo libgmp-dev libzip-dev

# install lib deps
RUN docker-php-ext-configure opcache && docker-php-ext-install opcache
RUN docker-php-ext-configure intl && docker-php-ext-install intl
RUN docker-php-ext-configure pdo_mysql && docker-php-ext-install pdo_mysql
RUN docker-php-ext-configure xml && docker-php-ext-install xml
RUN docker-php-ext-configure iconv && docker-php-ext-install iconv
RUN docker-php-ext-configure mysqli && docker-php-ext-install mysqli
RUN docker-php-ext-configure gmp && docker-php-ext-install gmp
RUN docker-php-ext-configure bcmath && docker-php-ext-install bcmath
RUN docker-php-ext-configure zip && docker-php-ext-install zip
RUN docker-php-ext-configure sockets && docker-php-ext-install sockets

# install pecl deps
RUN pecl install decimal && docker-php-ext-enable decimal
RUN pecl install redis && docker-php-ext-enable redis
RUN pecl install igbinary && docker-php-ext-enable igbinary
RUN pecl install mongodb && docker-php-ext-enable mongodb
RUN cd /tmp && rm -rf phpiredis && git clone https://github.com/nrk/phpiredis.git && cd phpiredis && phpize && ./configure --enable-phpiredis && make && make install && cd .. && docker-php-ext-enable phpiredis

# composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# configure limits
RUN echo 'memory_limit=-1' > /usr/local/etc/php/conf.d/memory_limit.ini

# run
ENTRYPOINT [ "composer", "install", "-n" ]
