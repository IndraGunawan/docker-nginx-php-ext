FROM indragunawan/nginx-php:latest

MAINTAINER Indra Gunawan <guind.online@gmail.com>

# Install Cassandra driver
RUN \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        cmake \
        g++ \
        libgmp-dev \
        libpcre3-dev \
        libssl-dev \
        libuv-dev \
        make \
        openssl \
        pkg-config \
    && cd /tmp \
    && git clone https://github.com/datastax/php-driver.git php-driver \
    && cd php-driver \
    && git submodule update --init \
    && cd ext \
    && ./install.sh \
    && rm -rf /tmp/php-driver \
    && echo 'extension=cassandra.so' > /etc/php/mods-available/cassandra.ini \
    && ln -s /etc/php/mods-available/cassandra.ini /etc/php/7.0/fpm/conf.d/20-cassandra.ini \
    && ln -s /etc/php/mods-available/cassandra.ini /etc/php/7.0/cli/conf.d/20-cassandra.ini

# NodeJS and NPM
RUN \
    curl -sL https://deb.nodesource.com/setup_4.x | bash - \
    && apt-get install -y nodejs jpegoptim \
    && npm install -g npm \
    && npm install -g bower \
    && npm install -g gulp \
    && echo '{ "allow_root": true }' > ~/.bowerrc

# Clear cache
RUN \
    apt-get clean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
