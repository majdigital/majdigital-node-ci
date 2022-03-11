FROM jenkins/jnlp-slave

USER root

# Install curl
RUN apt-get update \
  && apt-get upgrade -y \
  && apt-get install -y curl

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - \
  && apt-get install -y nodejs \
  && apt-get install -y rpm \
  && apt-get install -y ruby ruby-dev rubygems build-essential \
  && gem install --no-document --no-force fpm

# Install the latest versions of Google Chrome and Chromedriver
RUN export DEBIAN_FRONTEND=noninteractive \
  && apt-get install unzip \
  # Change to desired version of chrome here
  && CHROME_VERSION="99" \
  && CHROME_VERSION=$(curl -sL "https://chromedriver.storage.googleapis.com/LATEST_RELEASE_$CHROME_VERSION") \
  && DL="https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_$CHROME_VERSION-1_amd64.deb" \
  && curl -sL "$DL" > /tmp/chrome.deb \
  && apt install --no-install-recommends --no-install-suggests -y \
    /tmp/chrome.deb \
  && CHROMIUM_FLAGS='--no-sandbox --disable-dev-shm-usage' \
  # Patch Chrome launch script and append CHROMIUM_FLAGS to the last line:
  && sed -i '${s/$/'" $CHROMIUM_FLAGS"'/}' /opt/google/chrome/google-chrome \
  && curl -sL "https://chromedriver.storage.googleapis.com/$CHROME_VERSION/chromedriver_linux64.zip" -o /tmp/driver.zip \
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
RUN npm install yarn clever-tools -g

USER jenkins
