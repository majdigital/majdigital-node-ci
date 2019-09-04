FROM jenkins/jnlp-slave

USER root

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash -
RUN apt-get install -y nodejs

RUN apt-get install -y rpm

RUN apt-get install -y ruby ruby-dev rubygems build-essential
RUN gem install --no-ri --no-rdoc fpm

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys "379CE192D401AB61" && echo "deb https://dl.bintray.com/clevercloud/deb stable main" | tee -a /etc/apt/sources.list && apt-get update && apt-get install clever-tools

USER jenkins
