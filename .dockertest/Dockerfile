ARG RUBY_VERSION
# See explanation below
FROM ruby:$RUBY_VERSION AS bundler_stage
ARG BUNDLER_VERSION

# Configure bundler and PATH
ENV LANG=C.UTF-8 \
  GEM_HOME=/bundle \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3
ENV BUNDLE_PATH $GEM_HOME
ENV BUNDLE_APP_CONFIG=$BUNDLE_PATH \
  BUNDLE_BIN=$BUNDLE_PATH/bin
ENV PATH /app/bin:$BUNDLE_BIN:$PATH

COPY Gemfile* ./
RUN gem install bundler:${BUNDLER_VERSION} && bundle install

# download node modules since we must download some private repositories
COPY . /app

ENV DEBIAN_FRONTEND noninteractive
ARG NODE_MAJOR
RUN apt-get update && \
    curl -sL https://deb.nodesource.com/setup_$NODE_MAJOR.x | bash - && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list && \
    apt update && \
    apt install -y build-essential yarn nodejs

WORKDIR /app

RUN RAILS_ENV=test bin/rails webpacker:yarn_install

#######################################################################################################################
# STAGE 2
#######################################################################################################################
FROM ruby:$RUBY_VERSION
ARG BUNDLER_VERSION
ARG NODE_MAJOR
ARG PG_MAJOR


# We use an external Aptfile to install extra packages
COPY .dockertest/Aptfile /tmp/Aptfile

RUN groupadd -g 10000 rails && \
    useradd -g rails -M -u 10000 -s /bin/bash -d /app rails && \
    apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
    curl -sL https://deb.nodesource.com/setup_$NODE_MAJOR.x | bash - && \
    curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list && \
    curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - && \
    echo 'deb http://apt.postgresql.org/pub/repos/apt/ buster-pgdg main' $PG_MAJOR > /etc/apt/sources.list.d/pgdg.list && \
    apt update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    $(cat /tmp/Aptfile | xargs) \
    nodejs \
    postgresql-client-$PG_MAJOR \
    yarn && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    truncate -s 0 /var/log/*log


# Configure bundler and PATH
ENV LANG=C.UTF-8 \
  GEM_HOME=/bundle \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3
ENV BUNDLE_PATH $GEM_HOME
ENV BUNDLE_APP_CONFIG=$BUNDLE_PATH \
  BUNDLE_BIN=$BUNDLE_PATH/bin
ENV PATH /app/bin:$BUNDLE_BIN:$PATH

# Create a directory for the app code
RUN mkdir -p /app && mkdir -p /bundle && chown rails:rails /app && chown rails:rails /bundle
# Copy the app code
COPY  --chown=rails:rails . /app
RUN chmod 777 /app/test/reports
# Copy gems and node modules from previous step.
COPY --from=bundler_stage --chown=rails:rails /bundle /bundle
COPY --from=bundler_stage --chown=rails:rails /app/node_modules /app/node_modules
COPY --from=bundler_stage --chown=rails:rails /app/yarn.lock /app/yarn.lock
USER rails
WORKDIR /app

RUN gem install bundler:$BUNDLER_VERSION && \
    bundle install && \
    DISABLE_SPRING=1 RAILS_ENV=test rails webpacker:compile ; \
    DISABLE_SPRING=1 RAILS_ENV=test rails assets:precompile && \
    rm -r .cache node_modules yarn.lock tmp/*

ENTRYPOINT ["bin/dockertest_entrypoint.sh"]
CMD ["rails", "test"]
