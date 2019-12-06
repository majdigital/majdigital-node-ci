FROM jenkins/jnlp-slave

USER root

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
  && apt-get install -y nodejs \
  && apt-get install -y rpm \
  && apt-get install -y ruby ruby-dev rubygems build-essential \
  && gem install --no-ri --no-rdoc fpm

# Install clever-tools
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 \
  --recv-keys "379CE192D401AB61" \
  && echo "deb https://dl.bintray.com/clevercloud/deb stable main" \
  | tee -a /etc/apt/sources.list \
  && apt-get update \
  && apt-get install clever-tools

USER jenkins
