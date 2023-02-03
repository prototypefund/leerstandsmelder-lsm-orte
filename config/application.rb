require_relative "boot"

require "rails/all"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module OrteBackend
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1
   
    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #

    # config.time_zone = 'Berlin'
    # config.active_record.default_timezone = :local
    # config.active_record.time_zone_aware_attributes = false
    # config.eager_load_paths << Rails.root.join("extras")
    
    config.action_cable.mount_path = '/cable'

    config.active_storage.replace_on_assign_to_many = false

    config.middleware.use Rack::Attack

    config.active_storage.content_types_to_serve_as_binary -= ['image/svg+xml']

    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
    end
  end
end
