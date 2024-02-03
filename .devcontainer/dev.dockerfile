FROM mcr.microsoft.com/devcontainers/ruby:1-3.2-bullseye

RUN su vscode -c "gem install rails webdrivers"
RUN su vscode -c "/usr/local/rvm/bin/rvm fix-permissions"

ENV RAILS_DEVELOPMENT_HOSTS=".githubpreview.dev,.preview.app.github.dev,.app.github.dev"
ENV ROOT="/workspaces/shopping_app"

WORKDIR ${ROOT}

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential  postgresql-client libpq-dev
COPY Gemfile ${ROOT}
COPY Gemfile.lock ${ROOT}

RUN bundle config set --local path .bundle
RUN mkdir -p ${ROOT}/.bundle
RUN chown -R vscode:vscode ${ROOT}/.bundle
RUN su vscode -c "bundle install"

RUN su vscode -c "bundle exec rails assets:precompile"