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

# Run database migrations (primary database only)
bundle exec rails db:migrate

echo "Build completed successfully!"
