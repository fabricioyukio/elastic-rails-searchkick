sidekiq_config = { url: ENV['JOB_WORKER_URL'] }

Sidekiq.configure_server do |config|
  config.redis = { url: ENV.fetch('REDIS_URL_SIDEKIQ', 'redis://localhost:6379/1') }
end

Sidekiq.configure_client do |config|
  config.redis = { url: ENV.fetch('REDIS_URL_SIDEKIQ', 'redis://localhost:6379/1') }
end
Searchkick.client_options = {
  url: 'http://elastic:9200',
  retry_on_failure: true,
  user: ENV['ELASTIC_USERNAME'] || 'elastic',
  password: ENV['ELASTIC_PASSWORD'] || 'changeme',
  transport_options:
    {
      request: { timeout: 250 },
      ssl: { verify: false }
    }
}

