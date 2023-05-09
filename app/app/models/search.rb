# == Schema Information
#
# Table name: searchs
#
#  id            :bigint           not null, primary key
#  keywords      :string(140)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Search < ApplicationRecord
  searchkick callbacks: :queue

  after_commit :reindex_async, if: -> (model) { model.previous_changes.key?("content") }

  validates :content, presence: true, length: { minimum: 3, maximum: 140 }

  default_scope { order(created_at: :desc) }

  paginates_per ENV['DEFAULT_PAGE_SIZE'].to_i


  def reindex_async
    SearchIndexerWorker.perform_async(self.id)
  end

  # def search_data
  #   {
  #     content: content
  #   }
  # end

end
