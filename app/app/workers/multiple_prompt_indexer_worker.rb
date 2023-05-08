require 'sidekiq/api'

class MultiplePromptIndexerWorker < ElasticSearchWorker

  def perform(search, promote_and_clean = true)
    puts "Reindexing Prompts..."
    index = Prompt.search(search).reindex(async: true, refresh_interval: '30s')
    promote_and_clean(Prompt, index) if promote_and_clean
    # loop do
    #   # Check the size of queue
    #   queue_size = Sidekiq::Queue.new('searchkick').size
    #   puts "Jobs left: #{queue_size}"
    #   # wait 5 seconds between checks
    #   sleep 5
    #   break if queue_size.zero?
    #   promote_and_clean(model, index) if promote_and_clean
    # end
  end

  def promote_and_clean(model, index)
    model.search_index.promote(index[:index_name], update_refresh_interval: true)
    # Remove old indexes
    model.search_index.clean_indices
  end
end