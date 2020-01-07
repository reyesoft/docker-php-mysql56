FROM debian:stretch

ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL en_US.UTF-8
ENV LANGUAGE en_US:en

# Base
RUN \
 apt-get update && \
 apt-get install -y --no-install-recommends locales apt-utils wget gnupg curl apt-transport-https lsb-release ca-certificates && \
 echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
 locale-gen en_US.UTF-8 && \
 /usr/sbin/update-locale LANG=en_US.UTF-8 && \
 update-ca-certificates && \
 apt-get autoclean && apt-get clean && apt-get autoremove

# Add more repo sources
RUN \
  echo "deb http://packages.dotdeb.org stretch all" >> /etc/apt/sources.list && \
  echo "deb-src http://packages.dotdeb.org stretch all" >> /etc/apt/sources.list && \
  wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
  echo "deb http://archive.ubuntu.com/ubuntu trusty universe" >> /etc/apt/sources.list && \
  echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" > /etc/apt/sources.list.d/php.list && \
  curl https://www.dotdeb.org/dotdeb.gpg | apt-key add -

# Install MySQL
RUN \
  apt-get update && \
  echo "mysql-server mysql-server/root_password password root" | debconf-set-selections && \
  echo "mysql-server mysql-server/root_password_again password root" | debconf-set-selections && \
  apt-get install -y --allow-unauthenticated \
    mysql-server-5.6 \
    mysql-client-5.6 \
    && \
  apt-get autoclean && apt-get clean && apt-get autoremove

# Install PHP 7.4
RUN \
  apt-get update && \
  apt-get install -y --allow-downgrades \
    git \
    zip \
    fonts-texgyre \
    php7.4-mysqlnd \
    php7.4-cli \
    php7.4-phpdbg \
    php7.4-mbstring \
    php7.4-curl \
    php7.4-intl \
    php7.4-gd \
    php7.4-zip \
    php7.4-xml \
    php7.4-soap \
    php7.4-sqlite3 \
    php7.4-bcmath \
    && \
  apt-get autoclean && apt-get clean && apt-get autoremove

# Install mcrypt dependecie
Run \
    apt-get install -y --no-install-recommends \
    php7.4-dev \
    libmcrypt-dev \
    php-pear \
    make \
    && \
    pecl channel-update pecl.php.net \
    && \
    pecl install mcrypt-1.0.2 \
    && \
    php -d extension=mcrypt.so

# Install wkhtmltox-0.12.3 because this library has a bug on oficial repo
# Required by by snappy (pdf)
RUN \
  apt-get install -y --no-install-recommends \
    xz-utils \
    libfontconfig1 \
    libxrender1 \
    && \
  wget -nv https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz && \
  tar xf wkhtmltox-0.12.4_linux-generic-amd64.tar.xz && \
  mv wkhtmltox/bin/wkhtmlto* /usr/bin/ && \
  ln -nfs /usr/bin/wkhtmltopdf /usr/local/bin/wkhtmltopdf

# Install composer
RUN curl -sS https://getcomposer.org/installer | php -- --filename=composer --install-dir=/usr/bin

# Install PHPUnit
RUN curl https://phar.phpunit.de/phpunit.phar > phpunit.phar && chmod +x phpunit.phar && mv phpunit.phar /usr/local/bin/phpunit

# Install Prestissimo
RUN composer global require hirak/prestissimo

