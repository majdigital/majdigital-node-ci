FROM jenkins/inbound-agent

USER root

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_12.x | bash - \
  && apt-get install -y nodejs \
  && apt-get install -y rpm \
  && apt-get install -y ruby ruby-dev rubygems build-essential \
  && gem install --no-ri --no-rdoc fpm

# Install the latest versions of Google Chrome and Chromedriver
RUN export DEBIAN_FRONTEND=noninteractive \
  && apt-get install \
    unzip \
  && \
#  DL=https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
  DL=https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_87.0.4280.66-1_amd64.deb \
  && curl -sL "$DL" > /tmp/chrome.deb \
  && apt install --no-install-recommends --no-install-suggests -y \
    /tmp/chrome.deb \
  && CHROMIUM_FLAGS='--no-sandbox --disable-dev-shm-usage' \
  # Patch Chrome launch script and append CHROMIUM_FLAGS to the last line:
  && sed -i '${s/$/'" $CHROMIUM_FLAGS"'/}' /opt/google/chrome/google-chrome \
  && BASE_URL=https://chromedriver.storage.googleapis.com \
#  && VERSION=$(curl -sL "$BASE_URL/LATEST_RELEASE") \
  && VERSION="87.0.4280.20" \
  && curl -sL "$BASE_URL/$VERSION/chromedriver_linux64.zip" -o /tmp/driver.zip \
  && unzip /tmp/driver.zip \
  && chmod 755 chromedriver \
  && mv chromedriver /usr/local/bin/ \
  # Remove obsolete files:
  && apt-get autoremove --purge -y \
    unzip \
  && apt-get clean \
  && rm -rf \
    /tmp/* \
    /usr/share/doc/* \
    /var/cache/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

# Install clever-tools
RUN npm install clever-tools -g

USER jenkins
