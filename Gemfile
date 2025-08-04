source "https://rubygems.org"

# Core Rails and dependencies
gem "rails", "~> 8.0.2"
gem "pg", "~> 1.1"
gem "puma", ">= 5.0"

# Asset pipeline and frontend
gem "sass-rails", ">= 6"
gem "sprockets-rails"
gem "dartsass-rails"

# Modern Rails frontend (Hotwire)
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"

# View and template engines
gem "haml-rails"
gem "html2haml"
gem "jbuilder"

# Authentication
gem "bcrypt", "~> 3.1.7"

# Timezone support
gem "tzinfo-data", platforms: %i[ windows jruby ]

# Rails background jobs and caching
gem "solid_cache"
gem "solid_queue"
gem "solid_cable"

# Performance and deployment
gem "bootsnap", require: false
gem "kamal", require: false
gem "thruster", require: false

group :development do
  gem "web-console"
  gem "debug", platforms: %i[ mri windows ], require: "debug/prelude"
  gem "brakeman", require: false
  gem "rubocop", require: false
  gem "rubocop-rails-omakase", require: false
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "database_cleaner-active_record"
end

group :development, :test do
  gem "rspec-rails"
  gem "factory_bot_rails"
end
