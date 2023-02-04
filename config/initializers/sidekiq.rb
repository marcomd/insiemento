Sidekiq.configure_server do |config|
  config.redis = if ENV['REDIS_URL'].present?
                   { url: ENV['REDIS_URL'] }
                 else
                   { host: ENV.fetch('REDIS_HOST', nil), port: ENV['REDIS_PORT'] || '6379' }
                 end
end

Sidekiq.configure_client do |config|
  config.redis = if ENV['REDIS_URL'].present?
                   { url: ENV['REDIS_URL'] }
                 else
                   { host: ENV.fetch('REDIS_HOST', nil), port: ENV['REDIS_PORT'] || '6379' }
                 end
end

schedule_file = 'config/schedule.yml'
Sidekiq::Cron::Job.load_from_hash(YAML.load_file(schedule_file)) if File.exist?(schedule_file) && Sidekiq.server?

if Rails.env.test?
  require 'sidekiq/testing'
  Sidekiq::Testing.fake! # fake is the default mode
end
