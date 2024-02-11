FROM mcr.microsoft.com/devcontainers/ruby:1.0.7-3.2-bullseye

RUN su vscode -c "gem install rails:7.1.1"
RUN su vscode -c "/usr/local/rvm/bin/rvm fix-permissions"

ENV RAILS_DEVELOPMENT_HOSTS=".githubpreview.dev,.preview.app.github.dev,.app.github.dev"
ENV ROOT="/workspaces/shopping_app"

WORKDIR ${ROOT}

RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential  postgresql-client libpq-dev

RUN bundle config set --local path .bundle