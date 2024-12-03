ARG RUBY_VERSION=3.1.6
FROM ruby:${RUBY_VERSION}-slim-bookworm AS base

ENV TZ=America/New_York

WORKDIR /app

ARG NODE_VERSION=21
ARG YARN_VERSION=1.22.22
ARG BUNDLER_VERSION=2.5.22
ENV RUBY_BASE_IMAGE=${RUBY_VERSION}-node-${NODE_VERSION}

RUN apt-get update && \
    apt-get upgrade -y --no-install-recommends && \
    apt-get autoremove -y && \
    apt --fix-broken install -y && \
    apt-get install -y --no-install-recommends curl wget unzip

RUN curl -sL https://deb.nodesource.com/setup_$NODE_VERSION.x | bash -

RUN mkdir -p /etc/apt/keyrings && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor -o /etc/apt/keyrings/yarn.gpg && \
    echo 'deb [signed-by=/etc/apt/keyrings/yarn.gpg] http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list

RUN apt-get update && \
    apt-get install -y --no-install-recommends nodejs yarn=${YARN_VERSION}-1

RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    git make pkg-config libxslt-dev libxml2-dev g++ libpq-dev libghc-zlib-dev zlib1g-dev

RUN apt --fix-broken install -y
RUN apt-get autoremove -y
#RUN apt install rolldice
# apt list --installed | grep rolldice
# Dependencies needed for chrome installation in downstream ruby projects |     gcc-10-base_10-20200411 and libgcc-s1_10-20200411
RUN wget https://mirrors.edge.kernel.org/ubuntu/pool/main/g/gcc-10/gcc-10-base_10-20200411-0ubuntu1_amd64.deb \
    && dpkg -i gcc-10-base_10-20200411-0ubuntu1_amd64.deb
RUN wget https://mirrors.edge.kernel.org/ubuntu/pool/main/g/gcc-10/libgcc-s1_10-20200411-0ubuntu1_amd64.deb \
    && dpkg -i libgcc-s1_10-20200411-0ubuntu1_amd64.deb

RUN rm -rf /usr/local/lib/ruby/gems/2.7.0/specifications/default
RUN rm -rf /var/lib/apt/lists*


COPY bin/vaultshell /bin

# Configure bundler
ENV LANG=C.UTF-8 \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3
