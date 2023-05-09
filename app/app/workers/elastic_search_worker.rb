# class ElasticSearchWorker
#   include Sidekiq::Worker
#   sidekiq_options queue: :searchkick, retry: 50, backtrace: true

#   def perform(id,class_name,s)
#     Searchkick::ProcessQueueWorker.new.perform(id,class_name,s)
#   end

# end