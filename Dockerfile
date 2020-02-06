ARG RUBY_VERSION=2.6.3
FROM ruby:${RUBY_VERSION}-slim-buster as base

ENV TZ=America/New_York

WORKDIR /app

ARG NODE_MAJOR=12
ARG YARN_VERSION=1.19.1
ARG BUNDLER_VERSION=2.0.2

RUN apt-get update && \
    apt-get install -y --no-install-recommends curl wget unzip && \
    rm -rf /var/lib/apt/lists*

RUN curl -sL https://deb.nodesource.com/setup_$NODE_MAJOR.x | bash -

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -  \
  && echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list

RUN apt-get update && \
    apt-get install -y --no-install-recommends nodejs yarn=${YARN_VERSION}-1 &&  \
    rm -rf /var/lib/apt/lists*

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git make pkg-config libxslt-dev libxml2-dev g++ libpq-dev libghc-zlib-dev zlib1g-dev &&  \
    rm -rf /var/lib/apt/lists*

RUN curl -Lo /tmp/envconsul.zip https://releases.hashicorp.com/envconsul/0.9.0/envconsul_0.9.0_linux_amd64.zip && \
    unzip /tmp/envconsul.zip -d /bin && \
    rm /tmp/envconsul.zip

# Configure bundler
ENV LANG=C.UTF-8 \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3
