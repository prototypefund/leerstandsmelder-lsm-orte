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

ENV BUNDLER_VERSION=2.3.23

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN gem install bundler:2.3.23

# RUN bundle config build.nokogiri --use-system-libraries

RUN bundle check || bundle install \
  && rm -rf $BUNDLE_PATH/cache/*.gem \
  && find $BUNDLE_PATH/gems/ -name "*.c" -delete \
  && find $BUNDLE_PATH/gems/ -name "*.o" -delete  


COPY package.json yarn.lock ./

RUN yarn install --check-files

COPY . ./ 

ENTRYPOINT ["./entrypoints/docker-entrypoint.sh"]
