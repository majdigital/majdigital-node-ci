FROM jenkins/jnlp-slave

USER root

# Install nodejs
RUN curl -sL https://deb.nodesource.com/setup_16 .x | bash - \
  && apt-get install -y nodejs \
  && apt-get install -y rpm \
  && apt-get install -y ruby ruby-dev rubygems build-essential \
  && gem install --no-ri --no-rdoc fpm

# Install clever-tools
RUN curl -fsSL https://clever-tools.clever-cloud.com/gpg/cc-nexus-deb.public.gpg.key | gpg --dearmor -o /usr/share/keyrings/cc-nexus-deb.gpg \
  && echo  "deb [signed-by=/usr/share/keyrings/cc-nexus-deb.gpg] https://nexus.clever-cloud.com/repository/deb stable main" | tee -a /etc/apt/sources.list \
  && apt-get update \
  && apt-get install clever-tools

# Install the latest versions of Google Chrome and Chromedriver
RUN export DEBIAN_FRONTEND=noninteractive \
  && apt-get install \
  unzip \
  && \
  DL=https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
  && curl -sL "$DL" > /tmp/chrome.deb \
  && apt install --no-install-recommends --no-install-suggests -y \
  /tmp/chrome.deb \
  && CHROMIUM_FLAGS='--no-sandbox --disable-dev-shm-usage' \
  # Patch Chrome launch script and append CHROMIUM_FLAGS to the last line:
  && sed -i '${s/$/'" $CHROMIUM_FLAGS"'/}' /opt/google/chrome/google-chrome \
  && BASE_URL=https://chromedriver.storage.googleapis.com \
  && VERSION=$(curl -sL "$BASE_URL/LATEST_RELEASE") \
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

# RUN npm install pm2 -g

USER jenkins
