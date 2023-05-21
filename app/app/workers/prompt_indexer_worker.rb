# frozen_string_literal: true

require 'sidekiq/api'

# performs background reindexing for Prompt
class PromptIndexerWorker
  include Sidekiq::Worker
  sidekiq_options queue: :searchkick, retry: 5, backtrace: true

  def perform(prompt_id)
    begin
      prompt = Prompt.find(prompt_id)
      prompt.reindex
    rescue ActiveRecord::RecordNotFound => e
      # while scheduled for deletion, the record might have been deleted
      logger.error "PromptIndexerWorker: #{e.message}"
    end
  end
end
