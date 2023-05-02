module ElasticsearchIndexer
  extend ActiveSupport::Concern

  included do
    after_commit :reindex_model

    def reindex_model
      updated_fields = self.previous_changes.keys

      elastic_search_fields_to_reindex = self.search_data.stringify_keys.keys
      return if self.previous_changes.keys.blank?
      ElasticsearchWorker.perform_async(self.id, self.class.name)
    end
  end
end