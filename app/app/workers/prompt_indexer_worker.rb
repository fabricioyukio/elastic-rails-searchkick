require 'sidekiq/api'

class PromptIndexerWorker < ElasticSearchWorker

  def perform(prompt_id)
    puts "Reindexing Prompt..."
    prompt = Prompt.find(prompt_id)
    prompt.reindex!
  end
end