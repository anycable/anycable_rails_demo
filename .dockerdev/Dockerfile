ARG RUBY_VERSION=3.3.0
ARG DISTRO_NAME=bullseye
ARG APP_USER=app_user

FROM ruby:$RUBY_VERSION-slim-$DISTRO_NAME AS base

ARG DISTRO_NAME

# Common dependencies
# Using --mount to speed up build with caching, see https://github.com/moby/buildkit/blob/master/frontend/dockerfile/docs/reference.md#run---mount
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  --mount=type=tmpfs,target=/var/log \
  rm -f /etc/apt/apt.conf.d/docker-clean; \
  echo 'Binary::apt::APT::Keep-Downloaded-Packages "true";' > /etc/apt/apt.conf.d/keep-cache; \
  apt-get update -qq && \
  DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    build-essential \
    gnupg2 \
    curl \
    less \
    git

ARG PG_MAJOR
RUN curl -sSL https://www.postgresql.org/media/keys/ACCC4CF8.asc | gpg --dearmor -o /usr/share/keyrings/postgres-archive-keyring.gpg \
  && echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/postgres-archive-keyring.gpg] https://apt.postgresql.org/pub/repos/apt/" \
    $DISTRO_NAME-pgdg main $PG_MAJOR | tee /etc/apt/sources.list.d/postgres.list > /dev/null
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  --mount=type=tmpfs,target=/var/log \
  apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    libpq-dev \
    postgresql-client-$PG_MAJOR

ARG NODE_MAJOR
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  --mount=type=tmpfs,target=/var/log \
  curl -sL https://deb.nodesource.com/setup_$NODE_MAJOR.x | bash - && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    nodejs

ARG YARN_VERSION=latest
RUN npm install -g yarn@$YARN_VERSION

# Configure bundler
ENV LANG=C.UTF-8 \
  BUNDLE_JOBS=4 \
  BUNDLE_RETRY=3

# Store Bundler settings in the project's root
ENV BUNDLE_APP_CONFIG=.bundle

# Upgrade RubyGems and install latest Bundler
RUN gem update --system && \
    gem install bundler

# Create a directory for the app code
RUN mkdir -p /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN gem update --system --quiet && \
    gem install --no-document bundle

EXPOSE 3000
# Use Bash as the default command
CMD ["/usr/bin/bash"]

FROM base AS development

ENV RAILS_ENV=development

COPY .dockerdev/Aptfile /tmp/Aptfile.dev
RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  --mount=type=tmpfs,target=/var/log \
  apt-get update -qq && DEBIAN_FRONTEND=noninteractive apt-get -yq dist-upgrade && \
  DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    $(grep -Ev '^\s*#' /tmp/Aptfile.dev | xargs)

# The production-builder image is responsible for installing dependencies and compiling assets
FROM base AS production-builder

ARG APP_USER

RUN groupadd --gid 1005 ${APP_USER} && \
    useradd --uid 1005 --gid ${APP_USER} --shell /bin/bash --create-home ${APP_USER}
USER ${APP_USER}
WORKDIR /home/${APP_USER}/app

# re-configure bundler
ENV RAILS_ENV=production \
    LANG=C.UTF-8 \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3 \
    BUNDLE_APP_CONFIG=/home/${APP_USER}/bundle \
    BUNDLE_PATH=/home/${APP_USER}/bundle \
    GEM_HOME=/home/${APP_USER}/bundle

COPY --chown=${APP_USER}:${APP_USER} Gemfile Gemfile.lock ./
RUN mkdir -p $BUNDLE_PATH \
    && bundle config --local deployment 'true' \
    && bundle config --local path "${BUNDLE_PATH}" \
    && bundle config --local without 'development test' \
    && bundle config --local clean 'true' \
    && bundle config --local no-cache 'true' \
    && bundle install --jobs=${BUNDLE_JOBS} \
    && rm -rf $BUNDLE_PATH/ruby/${RUBY_VERSION}/cache/* \
    && rm -rf /home/${APP_USER}/.bundle/cache/*

COPY --chown=${APP_USER}:${APP_USER} package.json yarn.lock ./
RUN yarn install --check-files

COPY --chown=${APP_USER}:${APP_USER} . .

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile

# production image definition
FROM ruby:${RUBY_VERSION}-slim-${DISTRO_NAME} AS production

ARG APP_USER

RUN --mount=type=cache,target=/var/cache/apt,sharing=locked \
  --mount=type=cache,target=/var/lib/apt,sharing=locked \
  --mount=type=tmpfs,target=/var/log \
  apt-get update -qq \
  && apt-get dist-upgrade -y \
  && DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
    curl \
    gnupg2 \
    less \
    tzdata \
    time \
    locales \
    libpq5 \
  && update-locale LANG=C.UTF-8 LC_ALL=C.UTF-8

RUN gem update --system && \
    gem install bundler

RUN groupadd --gid 1005 app_user \
  && useradd --uid 1005 --gid ${APP_USER} --shell /bin/bash --create-home ${APP_USER}
RUN mkdir /home/${APP_USER}/app
WORKDIR /home/${APP_USER}/app
USER ${APP_USER}

# Ruby/Rails env configuration
ENV RAILS_ENV=production \
    BUNDLE_APP_CONFIG=/home/${APP_USER}/bundle \
    BUNDLE_PATH=/home/${APP_USER}/bundle \
    GEM_HOME=/home/${APP_USER}/bundle \
    PATH="/home/${APP_USER}/app/bin:${PATH}" \
    LANG=C.UTF-8 \
    LC_ALL=C.UTF-8

EXPOSE 3000

COPY --chown=${APP_USER}:${APP_USER} . .

COPY --from=production-builder $BUNDLE_PATH $BUNDLE_PATH

COPY --from=production-builder /home/${APP_USER}/app/public/assets /home/${APP_USER}/app/public/assets
COPY --chown=${APP_USER}:${APP_USER} --from=production-builder /home/${APP_USER}/app/tmp/cache/bootsnap* /home/${APP_USER}/app/tmp/cache/

COPY --from=production-builder \
     --chown=${APP_USER}:${APP_USER} \
     /home/${APP_USER}/app/bin/docker-entrypoint \
     /usr/local/bin/docker-entrypoint

RUN chmod +x /usr/local/bin/docker-entrypoint

ENTRYPOINT ["docker-entrypoint"]

CMD ["./bin/rails", "server"]
