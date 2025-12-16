#!/usr/bin/env bash
# exit on error
set -o errexit

# Default to production if not set
export RAILS_ENV=${RAILS_ENV:-production}

# Prepare database (creates if needed, runs migrations)
bundle exec rails db:prepare

# Seed database if empty (only on first run)
# Check if both Users AND Categories exist
if bundle exec rails runner 'exit(User.count == 0 || Category.count == 0 ? 0 : 1)' 2>/dev/null; then
  echo "Database is empty or incomplete. Running seeds..."
  bundle exec rails db:seed
else
  echo "Database already seeded. Skipping..."
fi

# Start the server
bundle exec puma -C config/puma.rb
