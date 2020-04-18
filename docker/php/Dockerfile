FROM php:7.4-fpm

RUN apt-get update && apt-get install -y libicu-dev

RUN apt-get install -y libpq-dev libxslt-dev \
    && docker-php-ext-install pdo pdo_mysql mysqli 

RUN apt-get clean

RUN pecl install apcu
RUN docker-php-ext-enable apcu
RUN docker-php-ext-install intl opcache
RUN docker-php-ext-install xsl

WORKDIR /usr/share/nginx/html

RUN apt-get install wget -y && wget https://get.symfony.com/cli/installer -O - | bash
RUN mv /root/.symfony/bin/symfony /usr/local/bin/symfony

RUN apt-get install zip -y
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer
#CMD bash -c "composer install && php-fpm"

RUN apt-get install gnupg -y
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -
RUN echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update
RUN apt-get install yarn -y

ENV BLACKFIRE_SOCKET unix:///var/run/blackfire/agent.sock

RUN wget -q -O - https://packages.blackfire.io/gpg.key | apt-key add - && \
    echo "deb http://packages.blackfire.io/debian any main" | tee /etc/apt/sources.list.d/blackfire.list

RUN apt-get update && apt-get install blackfire-agent \
    blackfire-php


RUN version=$(php -r "echo PHP_MAJOR_VERSION.PHP_MINOR_VERSION;") \
    && curl -A "Docker" -o /tmp/blackfire-probe.tar.gz -D - -L -s https://blackfire.io/api/v1/releases/probe/php/linux/amd64/$version \
    && mkdir -p /tmp/blackfire \
    && tar zxpf /tmp/blackfire-probe.tar.gz -C /tmp/blackfire \
    && mv /tmp/blackfire/blackfire-*.so $(php -r "echo ini_get ('extension_dir');")/blackfire.so \
    && printf "extension=blackfire.so\nblackfire.agent_socket=tcp://blackfire:8707\n" > $PHP_INI_DIR/conf.d/blackfire.ini \
    && rm -rf /tmp/blackfire /tmp/blackfire-probe.tar.gz

# Please note that the Blackfire Probe is dependent on the session module.
# If it isn't present in your install, you will need to enable it yourself.

COPY ./blackfire-init.sh /
RUN chmod +x /blackfire-init.sh