FROM susa4ostec/bitbucket-pipelines-php7.1-mysql

RUN apt-get update && apt-get install -y sudo && rm -rf /var/lib/apt/lists/*
RUN sudo add-apt-repository 'deb http://archive.ubuntu.com/ubuntu trusty universe'
RUN apt-get update
RUN apt install -y --force-yes mysql-server-5.6
RUN apt install -y --force-yes php7.1-soap php7.1-zip php7.1-sqlite3
RUN composer global require hirak/prestissimo
