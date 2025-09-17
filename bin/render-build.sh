#!/usr/bin/env bash
# exit on error
set -o errexit

# Install dependencies
bundle install

# Precompile assets (Rails 8 with Propshaft)
bundle exec rails assets:precompile

# Setup database
bundle exec rails db:create RAILS_ENV=production
bundle exec rails db:migrate RAILS_ENV=production