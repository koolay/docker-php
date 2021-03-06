FROM phusion/baseimage:0.9.19
MAINTAINER koolay

# Ensure UTF-8
RUN locale-gen en_US.UTF-8
ENV LANG       en_US.UTF-8
ENV LC_ALL     en_US.UTF-8

RUN /etc/my_init.d/00_regen_ssh_host_keys.sh
# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

RUN add-apt-repository ppa:ondrej/php
RUN apt-get update \
    && apt-get install -y --allow-unauthenticated --no-install-recommends \
    php5.6-dev php5.6-fpm php5.6-cli php5.6-memcached \
    php5.6-mysql php5.6-gd php5.6-json php5.6-ldap \
    php5.6-curl php5.6-intl php5.6-mcrypt php5.6-imagick php5.6-imap \
    ca-certificates php5.6-xdebug php5.6-mbstring php5.6-bcmath php5.6-xml php-pear php5.6-soap \
    pkg-config libssl-dev php5.6-igbinary php5.6-apcu \
    git

RUN pecl download redis && tar -xf redis* \
    && cd redis* \
    && phpize \
    && ./configure --enable-redis-igbinary \
    && make \
    && make install \
    && echo "extension=redis.so" > /etc/php/5.6/fpm/conf.d/redis.ini \
    && rm -rf redis*

RUN cd /tmp && curl -s -L -o ssdb.tar.gz  https://github.com/jonnywang/phpssdb/archive/v0.5.2.tar.gz.tar.gz  \
    && tar -zxf ssdb.tar.gz \
    && cd phpssdb-0.5.2.tar.gz \
    && phpize \
    && ./configure --enable-ssdb-igbinary \
    && make \
    && make install \
    && echo "extension=ssdb.so" >> `php --ini | grep "Loaded Configuration" | sed -e "s|.*:\s*||"` \
    && echo "extension=ssdb.so" > /etc/php/5.6/fpm/conf.d/ssdb.ini \
    && rm -rf /tmp/ssdb.tar.gz && rm -rdf /tmp/phpssdb-0.5.2.tar.gz

RUN git clone https://github.com/tideways/php-profiler-extension.git /tmp/php-profiler-extension \
    && cd /tmp/php-profiler-extension \
    && phpize \
    && ./configure \
    && make \
    && make install \
    && pecl install mongo \
    && echo "extension=tideways.so" > /etc/php/5.6/fpm/conf.d/tideways.ini \
    && echo "tideways.auto_prepend_library=0" >> /etc/php/5.6/fpm/conf.d/tideways.ini \
    && echo "extension=mongo.so" > /etc/php/5.6/fpm/conf.d/mongo.ini

#RUN pecl install channel://pecl.php.net/xhprof-0.9.4 && echo "extension=xhprof.so" > /etc/php/5.6/fpm/conf.d/xhprof.ini \
    #&& pecl install mongo && echo "extension=mongo.so" > /etc/php/5.6/fpm/conf.d/mongo.ini

#RUN pecl install channel://pecl.php.net/xhprof-0.9.4 && echo "extension=xhprof.so" > /etc/php/5.6/fpm/conf.d/xhprof.ini \
    #&& pecl install mongo && echo "extension=mongo.so" > /etc/php/5.6/fpm/conf.d/mongo.ini

#RUN php5enmod mcrypt && php5enmod memcached

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
RUN composer global require "squizlabs/php_codesniffer=*"

# xhgui
RUN git clone https://github.com/perftools/xhgui.git /home/app/xhgui \
    && cd /home/app/xhgui \
    && composer install --no-plugins --no-scripts --no-dev

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* /wheels/*
RUN mkdir -p /etc/service/fpm
COPY service.sh /etc/service/fpm/run
COPY init.sh /etc/my_init.d/init.sh
COPY prepare.sh /prepare.sh
RUN chmod +x /etc/service/fpm/run \
    && chmod +x /etc/my_init.d/init.sh \
    && chmod +x /prepare.sh \
    && bash /prepare.sh

# php config
COPY conf/php-fpm.conf /etc/php/5.6/fpm/php-fpm.conf
COPY conf/php.ini /etc/php/5.6/fpm/php.ini
COPY conf/pool.d/www.conf /etc/php/5.6/fpm/pool.d/www.conf
COPY ./xhgui.config.php /home/app/xhgui/config/config.php

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

VOLUME ["/home/app/webapp"]
