FROM ruby:${RUBY_VERSION:-2.7.6-alpine} AS build-env

ARG BUNDLER_VERSION=2.1.2
ARG NODE_ENV=development
ARG RAILS_ENV=development
ARG RAILS_ROOT=/app
ARG BUILD_PACKAGES="build-base curl-dev git"
ARG DEV_PACKAGES="mysql-dev mariadb-connector-c-dev yaml-dev zlib-dev nodejs yarn"
ARG RUBY_PACKAGES="tzdata"

ENV RAILS_ENV=${RAILS_ENV:-development} \
  NODE_ENV=${NODE_ENV:-development} \
  BUNDLER_VERSION=${BUNDLER_VERSION:-2.1.2} \
  BUNDLE_APP_CONFIG="$RAILS_ROOT/.bundle" \
  BUNDLE_PATH='vendor/bundle'

ENV GEM_HOME="/usr/local/bundle"
ENV PATH $GEM_HOME/bin:$GEM_HOME/gems/bin:$PATH

# install packages
RUN apk update \
  && apk upgrade \
  && apk add --update --no-cache $BUILD_PACKAGES $DEV_PACKAGES \
  $RUBY_PACKAGES

# Default directory
WORKDIR $RAILS_ROOT

# Install gems
COPY Gemfile* package.json yarn.lock ./
RUN bundle config --global frozen 1 \
  && bundle install --path=vendor/bundle
RUN yarn install
COPY . .
RUN bin/rails assets:precompile

############### Build step done ###############


FROM ruby:2.7.6-alpine
ARG RAILS_ROOT=/app
ARG PACKAGES="tzdata mysql-client mariadb-connector-c-dev nodejs bash"
ENV RAILS_ENV=production
ENV BUNDLE_APP_CONFIG="$RAILS_ROOT/.bundle"
WORKDIR $RAILS_ROOT

# install packages
RUN apk update \
  && apk upgrade \
  && apk add --update --no-cache $PACKAGES

COPY --from=build-env $RAILS_ROOT $RAILS_ROOT
ENTRYPOINT ["bundle", "exec"]
EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]