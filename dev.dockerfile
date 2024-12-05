# syntax = docker/dockerfile:1

# This Dockerfile is designed for production, not development. Use with Kamal or build'n'run by hand:
# docker build -t my-app .
# docker run -d -p 80:80 -p 443:443 --name my-app -e RAILS_MASTER_KEY=<value from config/master.key> my-app

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version
ARG RUBY_VERSION=3.3.4
FROM docker.io/library/ruby:$RUBY_VERSION-slim AS base

# Install dependencies (build tools and libraries for native gem compilation)
RUN apt-get update -qq && apt-get install -y \
    build-essential \
    libpq-dev \
    libxml2-dev \
    libxslt1-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    zlib1g-dev \
    nodejs \
    yarn \
    && rm -rf /var/lib/apt/lists/*

# Rails app lives here
WORKDIR /rails

# Set development environment
ENV RAILS_ENV="development" \
    BUNDLE_WITHOUT=""

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy application code
COPY . .

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Run and own only the runtime files as a non-root user for security
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp
USER 1000:1000

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/dev-docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 5000
CMD ["./bin/rails", "server", "-b", "0.0.0.0"]