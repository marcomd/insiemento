host = 'www.fitness.io'
host_port = 3100
Rails.application.default_url_options = { host:, port: host_port }

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports.
  config.consider_all_requests_local = true

  # Enable/disable caching. By default caching is disabled.
  # Run rails dev:cache to toggle caching.
  if Rails.root.join('tmp/caching-dev.txt').exist?
    config.action_controller.perform_caching = true
    config.action_controller.enable_fragment_cache_logging = true

    config.cache_store = :memory_store
    config.public_file_server.headers = {
      'Cache-Control' => "public, max-age=#{2.days.to_i}",
    }
  else
    config.action_controller.perform_caching = false

    config.cache_store = :null_store
  end

  # Store uploaded files on the local file system (see config/storage.yml for options).
  config.active_storage.service = :local

  # Don't care if the mailer can't send.

  config.action_mailer.perform_caching = false

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Highlight code that triggered database queries in logs.
  config.active_record.verbose_query_logs = true

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  # Suppress logger output for asset requests.
  config.assets.quiet = true

  # Raises error for missing translations.
  # config.action_view.raise_on_missing_translations = true

  # Use an evented file watcher to asynchronously detect changes in source code,
  # routes, locales, etc. This feature depends on the listen gem.
  config.file_watcher = ActiveSupport::EventedFileUpdateChecker

  # Configure action mailer
  config.default_url_options = { host:, port: host_port }
  config.action_mailer.default_url_options = config.default_url_options
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = {
    user_name: Rails.application.credentials.smtp[:development][:username],
    password: Rails.application.credentials.smtp[:development][:password],
    address: 'smtp.mailtrap.io',
    domain: 'smtp.mailtrap.io',
    port: '2525',
    authentication: :cram_md5,
  }
  config.action_mailer.perform_caching = false
  config.action_mailer.preview_path = Rails.root.join('app/mailers/previews')

  # Action cable configuration
  config.action_cable.url = "ws://#{host}:#{host_port}/cable"
  config.web_socket_server_url = "ws://#{host}:#{host_port}/cable"
  config.action_cable.allowed_request_origins ||= []
  config.action_cable.allowed_request_origins << "http://#{host}:#{host_port}"
  config.action_cable.allowed_request_origins << "ws://#{host}:#{host_port}"
  config.action_cable.allowed_request_origins << "wss://#{host}:#{host_port}"

  config.hosts << 'insiemento.local'
  config.hosts << 'fitness.insiemento.local'
  config.hosts << 'rspec.insiemento.local'
  config.hosts << 'wrong.insiemento.local'
  config.hosts << 'rspec.local'
  config.hosts << 'www.fitness.io'
end
