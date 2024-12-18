ARG RUBY_VERSION=3.1.6
FROM ruby:${RUBY_VERSION}-slim-bookworm AS base

ENV TZ=America/New_York

WORKDIR /app

ARG NODE_VERSION=16
ARG YARN_VERSION=1.22.22
ARG BUNDLER_VERSION=2.5.22
ENV RUBY_BASE_IMAGE=${RUBY_VERSION}-node-${NODE_VERSION}

RUN apt-get update && \
    apt-get upgrade -y --no-install-recommends && \
    apt-get autoremove -y && \
    apt --fix-broken install -y && \
    apt-get install -y --no-install-recommends curl wget unzip && \
    apt-get autoremove -y && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

# Add Node.js repository & Yarn Repositories
RUN curl -sL https://deb.nodesource.com/setup_$NODE_VERSION.x | bash - && \
    mkdir -p /etc/apt/keyrings && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor -o /etc/apt/keyrings/yarn.gpg && \
    echo 'deb [signed-by=/etc/apt/keyrings/yarn.gpg] http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list

# Install Node.js, Yarn, and build tools
RUN apt-get update && \
apt-get install -y --no-install-recommends \
nodejs yarn=${YARN_VERSION}-1 \
git make pkg-config libxslt-dev libxml2-dev g++ \
libpq-dev libghc-zlib-dev zlib1g-dev && \
apt-get autoremove -y && \
apt-get clean && rm -rf /var/lib/apt/lists/*

# # Set up the Chrome repository - Chromie is about 130 mb smaller than chromium
RUN echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list && \
wget -q -O - https://dl.google.com/linux/linux_signing_key.pub | gpg --dearmor |  tee /etc/apt/trusted.gpg.d/google.gpg >/dev/null && \
# Install Google Chrome https://www.google.com/linuxrepositories/
apt-get update && apt-get install -y --no-install-recommends google-chrome-stable && \
apt-get clean && rm -rf /var/lib/apt/lists/*

COPY bin/vaultshell /bin

# Configure bundler
ENV LANG=C.UTF-8 \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3

# Remove unused default gems (adjust the Ruby version directory if needed)
RUN rm -rf /usr/local/lib/ruby/gems/3.1.0/specifications/default
