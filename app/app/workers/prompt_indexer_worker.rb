require 'sidekiq/api'

class PromptIndexerWorker < ElasticSearchWorker

  def perform(prompt_id)
    puts "Reindexing Prompt..."
    prompt = Prompt.find(prompt_id)
    prompt.reindex!
  end

  def bulk_reindex(promts, promote_and_clean = true)
    puts "Reindexing Prompts..."
    index = promts.reindex(async: true, refresh_interval: '30s')
    loop do
      # Check the size of queue
      queue_size = Sidekiq::Queue.new('searchkick').size
      puts "Jobs left: #{queue_size}"
      # wait 5 seconds between checks
      sleep 5
      break if queue_size.zero?
      promote_and_clean(model, index) if promote_and_clean
    end
  end
  def promote_and_clean(model, index)
    model.search_index.promote(index[:index_name], update_refresh_interval: true)
    # Remove old indexes
    model.search_index.clean_indices
  end
end