require 'spec_helper'
ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../config/environment', __dir__)
abort("The Rails environment is running in production mode!") if Rails.env.production?

require 'rspec/rails'
require 'database_cleaner/active_record'

Dir[Rails.root.join('spec', 'support', '**', '*.rb')].sort.each { |f| require f }

begin
  ActiveRecord::Migration.maintain_test_schema!
rescue ActiveRecord::PendingMigrationError => e
  abort e.to_s.strip
end

RSpec.configure do |config|
  fixtures_dir = Rails.root.join('spec/fixtures')
  config.fixture_path = fixtures_dir.to_s if fixtures_dir.exist?

  config.use_transactional_fixtures = false
  config.filter_rails_from_backtrace!

  config.include FactoryBot::Syntax::Methods
  config.include FiltersHelper, type: :helper
  config.include OAuthHelpers,  type: :request

  config.before(:suite) do
    DatabaseCleaner.clean_with(:truncation)
    DatabaseCleaner.strategy = :transaction
  end

  config.before(:each, js: true) { DatabaseCleaner.strategy = :truncation }
  config.around(:each) { |ex| DatabaseCleaner.cleaning { ex.run } }
end
