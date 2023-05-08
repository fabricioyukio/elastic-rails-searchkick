# Adds support for calling a sidekiq job to index the model
# that includes this module.

module Indexable
  extend ActiveSupport::Concern
  included do
    def index_elasticsearch
      ElasticSearchWorker.perform_async(self.class.to_s, id)
      self
    end
  end
end