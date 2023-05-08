require 'sidekiq/web'

Sidekiq.configure_server do |config|
  ActiveRecord::Base.configurations[Rails.env.to_s]['pool'] = 30
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://redis:6379/0'), id: nil }
end
Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDIS_URL', 'redis://redis:6379/0'), id: nil }
end
Sidekiq.strict_args!(false)