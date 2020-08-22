require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Insiemento
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.0
    #config.active_record.belongs_to_required_by_default = false

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    config.time_zone = 'Rome'

    config.i18n.default_locale = :it
    config.i18n.available_locales = [:en, :it]

    # config.assets.precompile += %w[active_admin.scss active_admin.js]

    #config.active_job.queue_adapter = :sidekiq
    #config.action_mailer.deliver_later_queue_name = "default_mailer"

    config.active_storage.variant_processor = :vips

    config.autoload_paths += %W(#{Rails.root}/app/models/payments #{Rails.root}/app/models/subscriptions)
  end
end
