FROM php:7.4-fpm

# Install dependencies
RUN apt-get update -y && apt-get install -y libmcrypt-dev openssl zip unzip vim
RUN su -
RUN apt-get update -y && apt-get install -y sudo
RUN usermod -aG sudo root
RUN sudo -s

# Env
ENV NODE_VERSION 14.17.0
ENV NVM_LINK https://raw.githubusercontent.com/nvm-sh/nvm/v0.38.0/install.sh
ENV APP_PORT 8000

# Install Node
RUN curl -sL $NVM_LINK -o install_nvm.sh
RUN bash install_nvm.sh
ENV NVM_DIR ~/.nvm

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Setup application
WORKDIR /app
COPY . /app

RUN composer install

# Run application
CMD php artisan serve --host=0.0.0.0 --port=$APP_PORT

# Expose port
EXPOSE $APP_PORT
