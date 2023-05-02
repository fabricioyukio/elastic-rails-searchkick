class ElasticsearchWorker
  include Sidekiq::Worker
  def perform(id, klass)
    begin
      klass.constantize.find(id.to_s).reindex
    rescue => e
      # Handle exception
    end
  end
end