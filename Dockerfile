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
    php5.6-curl php5.6-intl php5.6-mcrypt php5.6-imagick php5.6-imap ca-certificates php5.6-xdebug

#RUN php5enmod mcrypt && php5enmod memcached

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

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

ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

VOLUME ["/home/app/webapp"]
