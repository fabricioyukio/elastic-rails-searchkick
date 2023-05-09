require 'sidekiq/api'

class PromptIndexerWorker
  include Sidekiq::Worker
  sidekiq_options queue: :searchkick, retry: 5, backtrace: true

  def perform(prompt_id)
    puts "\n\nReindexing Prompt #{prompt_id}...\n\n\n\n"
    prompt = prompt_id.is_a?(Prompt) ? prompt_id :Prompt.find(prompt_id)
    prompt.reindex
  end
end