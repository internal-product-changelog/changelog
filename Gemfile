source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.2.2"

# Core
gem "rails", "~> 7.0.6"
gem "puma", "~> 5.6.6"

# Asset pipeline
gem "sprockets-rails"

# Frontend
gem "bootstrap", "~> 5.2.0"
gem "importmap-rails", "~> 1.2.1"
gem "material_icons", "~> 4.0.0"
gem "sassc-rails", "~> 2.1.2"
gem "simple_form", "~> 5.2.0"
gem "stimulus-rails", "~> 1.2.1"
gem "turbo-rails", "~> 1.4.0"
gem "hotwire-rails"

# Database
gem "activerecord-import", "~> 1.4.1"
gem "pg", "~> 1.1"

# Active Storage
gem "active_storage_validations", "~> 1.0.4"

# Authentication
gem "api-auth", "~> 2.5.1"
gem "devise", "~> 4.8"
gem "devise-i18n", "~> 1.11.0"
gem "omniauth", "~> 2.1.1"
gem "omniauth-google-oauth2", "~> 1.1.1"
gem "omniauth-rails_csrf_protection", "~> 1.0.1"

# Authorization
gem "cancancan", "~> 3.5.0"

# View components
gem "view_component", "~> 2.62.0"

# API
gem "jbuilder", "~> 2.11.5"
gem "rest-client", "~> 2.1.0"

# Redis
gem "redis-rails", "~> 5.0"

# Search
gem "ransack", "~> 3.2"

# Pagination
gem "kaminari", "~> 1.2.2"

# CORS
gem "rack-cors", "~> 2.0.1"

# AWS
gem "aws-sdk-s3", "~> 1.131.0", require: false
gem "aws-sdk-secretsmanager", "~> 1.67", require: false

# Timezone
gem "tzinfo-data", "~> 2.0.5", platforms: %i[mingw mswin x64_mingw jruby]

# Performance
gem "bootsnap", "~> 1.16.0", require: false

# SFTP
gem "net-sftp", "~> 4.0.0"

# Environment variables
gem "dotenv-rails", "~> 2.8.1"

# Debugging
gem "pry", "~> 0.14.1"
gem "sentry-ruby", "~> 5.10.0"
gem "sentry-rails", "~> 5.10.0"

# Jobs
gem "delayed_job_active_record", "~> 4.1"
gem "delayed_cron_job", "~> 0.9.0"
gem "delayed_job_web", "~> 1.4.4"

# Documents
gem "hexapdf", "~> 0.32.0"
gem "rubyXL", "~> 3.4"

group :development, :test do
  # Debugging
  gem "debug", "~> 1.8.0", platforms: %i[mri mingw x64_mingw]
  # Testing
  gem "factory_bot_rails", "~> 6.2.0"
  gem "rspec-rails", "~> 6.0.0"
  # Linting
  gem "standard", "~> 1.25.0"
  gem "guard-rspec", require: false
  gem "capybara"
end

group :development do
  # Error handling
  gem "annotate", "~> 3.2.0"
  gem "binding_of_caller", "~> 1.0.0"
  gem "web-console", "~> 4.2.0"
  gem "better_errors", "~> 2.10.1"
end

group :test do
  # Testing
  gem "database_cleaner-active_record", "~> 1.99.0"
  gem "faker", "~> 3.2.0"
  gem "rspec_junit_formatter", "~> 0.6.0"
  gem "simplecov", "~> 0.21.2", require: false
  gem "simplecov_json_formatter", "~> 0.1.4"
  gem "shoulda-matchers", "~> 5.3.0"
  gem "webmock", "~> 3.18.1"
  gem "rails-controller-testing"
end

gem "flipper-active_record", "~> 0.28.0"
gem "flipper-ui", "~> 0.28.0"

gem "activeadmin", "~> 2.13"
