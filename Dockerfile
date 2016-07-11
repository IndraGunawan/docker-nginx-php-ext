FROM indragunawan/nginx-php:latest

MAINTAINER Indra Gunawan <guind.online@gmail.com>

# NodeJS and NPM
RUN \
    curl -sL https://deb.nodesource.com/setup_4.x | bash - \
    && apt-get install -y nodejs jpegoptim \
    && npm install -g npm \
    && npm install -g bower \
    && npm install -g gulp \
    && echo '{ "allow_root": true }' > ~/.bowerrc

# Install Cassandra driver
RUN \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        cmake \
        g++ \
        libgmp-dev \
        libicu-dev \
        libssl-dev \
        libuv-dev \
        make \
        openssl \
        pkg-config \
        uuid-dev \
        zlib1g-dev

RUN git clone --branch v1.1.0 https://github.com/datastax/php-driver.git /tmp/php-driver \
    && cd /tmp/php-driver \
    && git submodule update --init \
    && cd ext \
    && ./install.sh \
    && rm -rf /tmp/php-driver \
    && echo 'extension=cassandra.so' > /etc/php/mods-available/cassandra.ini \
    && ln -s /etc/php/mods-available/cassandra.ini /etc/php/7.0/fpm/conf.d/20-cassandra.ini \
    && ln -s /etc/php/mods-available/cassandra.ini /etc/php/7.0/cli/conf.d/20-cassandra.ini

# Clear cache
RUN \
    apt-get clean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
