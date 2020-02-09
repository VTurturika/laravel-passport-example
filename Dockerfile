FROM chialab/php-dev:7.2-apache

# create non-root user
RUN useradd --create-home --shell /bin/bash --uid 1000 user

# init xdebug
RUN echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/xdebug.ini \
 && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/xdebug.ini

# create cache directory for composer
RUN mkdir /.composer && chmod 777 -R /.composer
