require 'sidekiq/api'

class MultiplePromptIndexerWorker
  include Sidekiq::Worker
  sidekiq_options queue: :searchkick, retry: 5, backtrace: true

  def perform(search, promote_and_clean = true)
    puts "Reindexing Prompts..."
    index = Prompt.search(search)
    Prompt.reindex
    promote_and_clean(Prompt, index) if promote_and_clean

  end

  def promote_and_clean(model, index)
    model.search_index.promote(index[:index_name], update_refresh_interval: true)
    # Remove old indexes
    model.search_index.clean_indices
  end
end