#!/usr/bin/env bash
# exit on error
set -o errexit

# Prepare database (creates if needed, runs migrations)
bundle exec rails db:prepare

# Seed database if empty (only on first run)
if bundle exec rails runner 'exit(User.count == 0 ? 0 : 1)' 2>/dev/null; then
  echo "Database is empty. Running seeds..."
  bundle exec rails db:seed
else
  echo "Database already seeded. Skipping..."
fi

# Start the server
bundle exec puma -C config/puma.rb
