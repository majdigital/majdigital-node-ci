FROM jenkins/inbound-agent

USER root

# Update packages
RUN apt-get update && apt-get upgrade -y

# Install nodejs
RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash - \
  && apt-get install -y nodejs npm rpm ruby ruby-dev rubygems build-essential \
  && gem install --no-document --no-force fpm

# Install chromium
RUN apt-get install -y chromium

# Install clever-tools
RUN npm install yarn clever-tools -g

# Output versions
RUN echo "node version: $(node -v)"
RUN echo "npm version: $(npm -v)"
RUN echo "chromiun version: $(chromium --product-version)"

USER jenkins
