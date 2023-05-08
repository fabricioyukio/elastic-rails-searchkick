class ElasticSearchWorker
  include Sidekiq::Worker
  sidekiq_options queue: :searchkick, retry: 50, backtrace: true

  def perform(id,class_name,s)
    indexable = class_name.constantize.search(s).find(id)
    indexable.reindex!
  end

end