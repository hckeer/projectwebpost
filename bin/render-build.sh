#!/usr/bin/env bash
# exit on error
set -o errexit

export RAILS_ENV=${RAILS_ENV:-production}

# Install dependencies
bundle install
npm ci

# Build CSS
npm run build:css

# Precompile assets (skip database connection)
RAILS_ENV=production DATABASE_URL=sqlite3:storage/dummy.sqlite3 bundle exec rails assets:precompile

# Run database migrations (primary database only)
bundle exec rails db:migrate

echo "Build completed successfully!"
