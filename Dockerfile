#
# Docker container to run osTicket under nginx.
#
# Copyright (c) 2016 Carlos Ferreyra <crypticmind@gmail.com>
#
# Please see README.md for details.
#
# VERSION 0.0.1
#
FROM phusion/baseimage:0.9.19
MAINTAINER Carlos Ferreyra <crypticmind@gmail.com>

# The base image's init process
CMD ["/sbin/my_init"]

# osTicket will be available on this port
EXPOSE 8080

# Install required packages
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get install -y nginx php-fpm php-mysql php-imap php-gd php-xml php-mbstring php-intl php-apcu net-tools git

# Disable dangerous option
RUN sed -i~ 's/.*cgi.fix_pathinfo=1/cgi.fix_pathinfo=0/' /etc/php/7.0/fpm/php.ini

# Catch PHP FPM worker output to help debugging
RUN sed -i~ 's/.*catch_workers_output.*/catch_workers_output = yes/' /etc/php/7.0/fpm/pool.d/www.conf

# Copy configuration file and deploy osTicket
COPY fs /

# Switch to select SETUP mode.
ENV OSTICKET_SETUP no

# Location of externalized configuration files
VOLUME /config

# Cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
