#!/usr/bin/env bash
# exit on error
set -o errexit

# Install dependencies
bundle install
npm ci

# Build CSS
npm run build:css

# Precompile assets
bundle exec rails assets:precompile

# Install Solid Cache and Queue migrations
bundle exec rails solid_cache:install
bundle exec rails solid_queue:install

# Run database migrations for ALL databases (primary, queue, cache)
bundle exec rails db:migrate
bundle exec rails db:migrate:queue
bundle exec rails db:migrate:cache

echo "Build completed successfully!"
