# frozen_string_literal: true

require 'sidekiq/api'

# batch indexing of prompts
class MultiplePromptIndexerWorker
  include Sidekiq::Worker
  sidekiq_options queue: :searchkick, retry: 5, backtrace: true

  def perform(search, promote_and_clean: true)
    puts "\n\n\nReindexing MULTIPLE  Prompts..."
    index = Prompt.reindex(mode: :async)[:index_name]
    puts "\nREINDEXED for search: #{search}\n\n"
    promote_and_clean('Prompt', index) if promote_and_clean
  end

  def promote_and_clean(model_name, index_name)
    model_name.constantize.search_index.promote(index_name, update_refresh_interval: true)
    # Remove old indexes
    model_name.constantize.search_index.clean_indices
    puts "\n\n\nPROMOTED and CLEANED for model: #{model_name} : #{index_name}\n\n"
  end
end