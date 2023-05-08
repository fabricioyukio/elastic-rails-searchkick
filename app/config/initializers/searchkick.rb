Searchkick.client =
  Elasticsearch::Client.new(
    url: ENV.fetch('ELASTICSEARCH_URL', 'http://elastic:9200'),
    retry_on_failure: true,
    transport_options: { request: { timeout: 250 } }
)

Searchkick.redis = ConnectionPool.new { Redis.new }