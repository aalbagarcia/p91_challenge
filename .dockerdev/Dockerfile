# Para la instalación de postgresql 10 en debian, utilicé este artículo:
# https://tecadmin.net/install-postgresql-on-debian/

ARG RUBY_VERSION
# See explanation below
FROM ruby:$RUBY_VERSION

ENV DEBIAN_FRONTEND noninteractive

ARG PG_MAJOR
ARG NODE_MAJOR
ARG BUNDLER_VERSION
ARG YARN_VERSION

# Add NodeJS to sources list
RUN curl -sL https://deb.nodesource.com/setup_$NODE_MAJOR.x | bash -

# Add Yarn to the sources list
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
  && echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list

# Install dependencies
# We use an external Aptfile for that, stay tuned
#COPY .dockerdev/Aptfile /tmp/Aptfile
COPY Aptfile /tmp/Aptfile
RUN apt-get update -qq && apt-get -yq dist-upgrade

# Add PostgreSQL to sources list
RUN curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | apt-key add - \
  && echo 'deb http://apt.postgresql.org/pub/repos/apt/ stretch-pgdg main' $PG_MAJOR > /etc/apt/sources.list.d/pgdg.list && \
  apt-get update

RUN addgroup --gid 1000 rails && \
    adduser --shell /bin/sh --uid 1000 --ingroup rails --gecos "" --disabled-password --home /home/rails rails && \
    apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    build-essential \
    postgresql-client-$PG_MAJOR \
    nodejs \
    yarn=$YARN_VERSION-1 \
    $(cat /tmp/Aptfile | xargs) && \
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

# Upgrade RubyGems and install required Bundler version
#RUN gem update --system && \
#    gem install bundler:$BUNDLER_VERSION
RUN gem install bundler:$BUNDLER_VERSION

# Create a directory for the app code
RUN mkdir -p /app /app/node_modules /app/tmp/cache /app/public/packs && chown rails:rails -R /app /bundle

USER rails

RUN mkdir /home/rails/.ssh/ && \
    ssh-keyscan -H github.com >> /home/rails/.ssh/known_hosts && \
    ssh-keyscan -H bitbucket.org >> /home/rails/.ssh/known_hosts

WORKDIR /app