Sidekiq.configure_server do |config|
  config.redis = {
      host: ENV['REDIS_HOST'],
      port: ENV['REDIS_PORT'] || '6379'
  }
end

Sidekiq.configure_client do |config|
  config.redis = {
      host: ENV['REDIS_HOST'],
      port: ENV['REDIS_PORT'] || '6379'
  }
end

schedule_file = "config/schedule.yml"
if File.exists?(schedule_file) && Sidekiq.server?
  Sidekiq::Cron::Job.load_from_hash YAML.load_file(schedule_file)
end

if Rails.env.test?
  require 'sidekiq/testing'
  Sidekiq::Testing.fake! # fake is the default mode
end
