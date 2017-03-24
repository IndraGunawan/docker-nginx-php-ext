FROM indragunawan/nginx-php:latest

MAINTAINER Indra Gunawan <guind.online@gmail.com>

# NodeJS and NPM
RUN \
    curl -sL https://deb.nodesource.com/setup_7.x | bash - \
    && apt-get install -y nodejs jpegoptim \
    && npm install -g npm \
    && npm install -g bower \
    && npm install -g gulp \
    && echo '{ "allow_root": true }' > ~/.bowerrc

# Install Yarn
RUN \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install yarn

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
        libelf1 \
        make \
        openssl \
        pkg-config \
        uuid-dev \
        zlib1g-dev

RUN git clone --branch v1.2.2 --recursive https://github.com/datastax/php-driver.git /tmp/php-driver \
    && cd /tmp/php-driver/ext \
    && ./install.sh \
    && echo 'extension=cassandra.so' > /etc/php/7.0/mods-available/cassandra.ini \
    && phpenmod cassandra

# Clear cache
RUN \
    apt-get clean \
    && apt-get autoremove \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
