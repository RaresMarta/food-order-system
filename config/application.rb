require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module FoodOrderSystem
  class Application < Rails::Application
    config.load_defaults 8.0

    config.generators.system_tests = nil

    config.generators do |g|
      g.test_framework :rspec
    end
  end
end
