require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(:default, Rails.env)

module SiteBlogRails
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 7.0

    config.generators do |g|
      g.test_framework  :rspec, fixture: false
      g.view_specs      false
      g.helper_specs    false
      g.factory_bot true
    end
    config.active_job.queue_adapter = :resque
    config.autoload_paths += %W(#{config.root}/lib)

    config.cache_store = :mem_cache_store

    config.action_mailer.perform_deliveries = true
    config.action_mailer.raise_delivery_errors = true

    config.time_zone = "UTC"
    config.active_record.default_timezone = :utc
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")
  end
end
