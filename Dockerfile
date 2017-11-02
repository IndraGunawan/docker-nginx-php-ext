FROM indragunawan/nginx-php:ubuntu-php7.0

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
    && apt-get install yarn libelf1

# Install Cassandra driver
RUN \
    apt-get update && apt-get install -y --no-install-recommends \
        cmake \
        g++ \
        libgmp-dev \
        openssl \
        libssl-dev \
        libpcre3-dev \
        make

RUN \
    cd /tmp \
    && wget --quiet http://downloads.datastax.com/cpp-driver/ubuntu/16.04/dependencies/libuv/v1.11.0/libuv_1.11.0-1_amd64.deb \
    && wget --quiet http://downloads.datastax.com/cpp-driver/ubuntu/16.04/dependencies/libuv/v1.11.0/libuv-dev_1.11.0-1_amd64.deb \
    && wget --quiet http://downloads.datastax.com/cpp-driver/ubuntu/16.04/dependencies/libuv/v1.11.0/libuv-dbg_1.11.0-1_amd64.deb \
    && dpkg -i libuv_1.11.0-1_amd64.deb \
    && dpkg -i libuv-dev_1.11.0-1_amd64.deb \
    && dpkg -i libuv-dbg_1.11.0-1_amd64.deb \

    && wget --quiet http://downloads.datastax.com/cpp-driver/ubuntu/16.04/cassandra/v2.7.0/cassandra-cpp-driver_2.7.0-1_amd64.deb \
    && wget --quiet http://downloads.datastax.com/cpp-driver/ubuntu/16.04/cassandra/v2.7.0/cassandra-cpp-driver-dev_2.7.0-1_amd64.deb \
    && wget --quiet http://downloads.datastax.com/cpp-driver/ubuntu/16.04/cassandra/v2.7.0/cassandra-cpp-driver-dbg_2.7.0-1_amd64.deb \
    && dpkg -i cassandra-cpp-driver_2.7.0-1_amd64.deb \
    && dpkg -i cassandra-cpp-driver-dev_2.7.0-1_amd64.deb \
    && dpkg -i cassandra-cpp-driver-dbg_2.7.0-1_amd64.deb \

    && wget --quiet http://downloads.datastax.com/php-driver/ubuntu/16.04/cassandra/v1.3.1/php7.0-cassandra-driver_1.3.1~stable-1_amd64.deb \
    && dpkg -i php7.0-cassandra-driver_1.3.1~stable-1_amd64.deb \

    && phpenmod cassandra

# Install wkhtmltopdf
RUN \
    apt-get update && apt-get install -y --no-install-recommends \
        wkhtmltopdf

# Install php-soap
RUN \
    apt-get update && apt-get install -y --no-install-recommends \
        php7.0-soap

# Clear cache
RUN \
    apt-get clean \
    && apt-get autoremove --purge \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
