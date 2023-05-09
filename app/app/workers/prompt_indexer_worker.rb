require 'sidekiq/api'

class PromptIndexerWorker
  include Sidekiq::Worker
  sidekiq_options queue: :searchkick, retry: 5, backtrace: true

  def perform(prompt_id)
    puts "\n\nReindexing Prompt #{prompt_id}...\n\n"
    prompt = Prompt.find(prompt_id)
    prompt.reindex unless prompt.nil?
    puts "\n\nReindexed Prompt #{prompt.id}...\n\n\n\n"
  end
end