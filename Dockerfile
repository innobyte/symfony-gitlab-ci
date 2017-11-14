FROM ubuntu:16.04
MAINTAINER Alin Alexandru <alin.alexandru@innobyte.com>

ADD ondrej-ubuntu-php-xenial.list /etc/apt/sources.list.d/

RUN apt-get update -y \
    && apt-get install -y --no-install-recommends \
        wget nghttp2 libnghttp2-dev \
        php7.1-cli php7.1-curl php7.1-common php7.1-intl php7.1-mbstring \
        php7.1-zip php7.1-opcache php7.1-json php7.1-xml php7.1-mysql php7.1-gmp \
    && wget https://curl.haxx.se/download/curl-7.56.1.tar.bz2 \
    && tar -xvjf curl-7.56.1.tar.bz2 && cd curl-7.56.1 \
    && ./configure --with-nghttp2 --prefix=/usr/local \
    && make && make install && ldconfig \
    && cd .. && rm -rf curl-7.56.1.tar.bz2 curl-7.56.1 \
    && rm -rf /var/lib/apt/lists/*

# PHP Configuration
RUN echo "memory_limit=-1" > $PHP_INI_DIR/conf.d/memory-limit.ini
RUN echo "date.timezone=UTC" > $PHP_INI_DIR/conf.d/date_timezone.ini

# Install composer and put binary into $PATH
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/ \
    && ln -s /usr/local/bin/composer.phar /usr/local/bin/composer

# Install phpunit and put binary into $PATH
RUN curl -sSLo phpunit.phar https://phar.phpunit.de/phpunit.phar \
    && chmod 755 phpunit.phar \
    && mv phpunit.phar /usr/local/bin/ \
    && ln -s /usr/local/bin/phpunit.phar /usr/local/bin/phpunit

# Install PHP Code sniffer
RUN curl -OL https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar \
    && chmod 755 phpcs.phar \
    && mv phpcs.phar /usr/local/bin/ \
    && ln -s /usr/local/bin/phpcs.phar /usr/local/bin/phpcs \
    
# Install deployer
RUN curl -LO https://deployer.org/deployer.phar \
    && mv deployer.phar /usr/local/bin/dep \
    && chmod +x /usr/local/bin/dep
