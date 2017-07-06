FROM indragunawan/nginx-php:ubuntu

MAINTAINER Indra Gunawan <guind.online@gmail.com>

# NodeJS and NPM
RUN \
    apt-get update \
    && curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get install -y nodejs jpegoptim \
    && npm install -g npm \
    && npm install -g bower \
    && npm install -g gulp \
    && echo '{ "allow_root": true }' > ~/.bowerrc \

    # Install Yarn
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install yarn libelf1 \

    # Install Cassandra driver
    && apt-get install -y --no-install-recommends \
        cmake \
        g++ \
        libgmp-dev \
        libssl-dev \
        libuv-dev \
        libpcre3-dev \
        make

RUN \
    cd /tmp && git clone -b 'v1.3.1' --single-branch --depth 1 --recursive https://github.com/datastax/php-driver.git php-driver \
    && cd php-driver/ext && ./install.sh \
    && echo 'extension=cassandra.so' > /etc/php/7.1/mods-available/cassandra.ini \
    && phpenmod cassandra

# Clear cache
RUN \
    apt-get clean \
    && apt-get autoremove --purge \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
