FROM jenkins/inbound-agent

USER root

# Update packages
RUN apt update && apt upgrade -y

# Install dependencies
RUN apt install -y curl build-essential

# Install Node.js
RUN curl -sL https://deb.nodesource.com/setup_16.x | bash
RUN apt install -y nodejs

# Install yarn & clever-tools
RUN npm install yarn clever-tools -g

# Install Google Chrome
RUN export DEBIAN_FRONTEND=noninteractive \
  && apt-get install unzip \
  && DL=https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb \
  && curl -sL "$DL" > /tmp/chrome.deb \
  && apt install --no-install-recommends --no-install-suggests -y /tmp/chrome.deb \
  && CHROMIUM_FLAGS='--no-sandbox --disable-dev-shm-usage' \
  # Patch Chrome launch script and append CHROMIUM_FLAGS to the last line:
  && sed -i '${s/$/'" $CHROMIUM_FLAGS"'/}' /opt/google/chrome/google-chrome \
  && apt-get autoremove --purge -y unzip \
  && apt-get clean \
  && rm -rf \
    /tmp/* \
    /usr/share/doc/* \
    /var/cache/* \
    /var/lib/apt/lists/* \
    /var/tmp/*

# Output versions
RUN echo "node version: $(node -v)"
RUN echo "npm version: $(npm -v)"
RUN echo "chrome version: $(google-chrome --version)"

USER jenkins
