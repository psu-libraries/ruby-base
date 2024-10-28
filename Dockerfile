ARG RUBY_VERSION=3.1.6
FROM ruby:${RUBY_VERSION}-slim-bookworm AS base

ENV TZ=America/New_York

WORKDIR /app

ARG NODE_VERSION=20
ARG YARN_VERSION=1.22.22
ARG BUNDLER_VERSION=2.5.22
ENV RUBY_BASE_IMAGE=${RUBY_VERSION}-node-${NODE_VERSION}

RUN apt-get update && \
    apt-get upgrade -y --no-install-recommends && \
    apt-get install -y --no-install-recommends curl wget unzip && \
    rm -rf /var/lib/apt/lists*

RUN curl -sL https://deb.nodesource.com/setup_$NODE_VERSION.x | bash -

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -  \
  && echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list

RUN apt-get update && \
    apt-get install -y --no-install-recommends nodejs yarn=${YARN_VERSION}-1 &&  \
    rm -rf /var/lib/apt/lists*

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git make pkg-config libxslt-dev libxml2-dev g++ libpq-dev libghc-zlib-dev zlib1g-dev &&  \
    rm -rf /var/lib/apt/lists*

# Dependencies needed for chrome installation in downstream ruby projects |     gcc-10-base_10-20200411 and libgcc-s1_10-20200411
RUN wget https://mirrors.edge.kernel.org/ubuntu/pool/main/g/gcc-10/gcc-10-base_10-20200411-0ubuntu1_amd64.deb \
    && dpkg -i gcc-10-base_10-20200411-0ubuntu1_amd64.deb
RUN wget https://mirrors.edge.kernel.org/ubuntu/pool/main/g/gcc-10/libgcc-s1_10-20200411-0ubuntu1_amd64.deb \
    && dpkg -i libgcc-s1_10-20200411-0ubuntu1_amd64.deb

RUN rm -rf /usr/local/lib/ruby/gems/2.7.0/specifications/default


COPY bin/vaultshell /bin

# Configure bundler
ENV LANG=C.UTF-8 \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3
