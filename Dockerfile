FROM ruby:${RUBY_VERSION:-2.7.6-alpine} AS build-env

RUN apk add --update --no-cache \
  binutils-gold \
  build-base \
  curl \
  file \
  g++ \
  gcc \
  git \
  less \
  libstdc++ \
  libffi-dev \
  libc-dev \ 
  linux-headers \
  libxml2-dev \
  libxslt-dev \
  libgcrypt-dev \
  make \
  netcat-openbsd \
  nodejs \
  openssl \
  pkgconfig \
  postgresql-dev \
  tzdata \
  yarn 

ARG DB_HOST=localhost
ARG POSTGRES_USER=lsm_orte
ARG POSTGRES_PASSWORD=lsm_orte00

ENV DB_HOST=${DB_HOST:-localhost}
ENV POSTGRES_USER=${POSTGRES_USER:-lsm_orte}
ENV POSTGRES_PASSWORD=${POSTGRES_PASSWORD:-lsm_orte00}

ENV GEM_HOME="/usr/local/bundle"
ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH

ENV BUNDLER_VERSION=2.3.23

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN gem install bundler:2.3.23

# RUN bundle config build.nokogiri --use-system-libraries

# RUN bundle check 
RUN bundle install

COPY package.json yarn.lock ./

RUN yarn install --check-files

COPY . ./ 

ENTRYPOINT ["./entrypoints/docker-entrypoint.sh"]
