# == Schema Information
#
# Table name: prompts
#
#  id            :bigint           not null, primary key
#  original_index          :string(255)
#  content         :text(512)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Prompt < ApplicationRecord
  searchkick callbacks: :queue

  # after_save :reindex_async
  # after_initialize :reindex_async
  after_commit :reindex_async
  # after_commit :reindex_async, if: -> (model) { model.previous_changes.key?("content") }

  validates :original_index, presence: true, numericality: { only_integer: true }
  validates :content, presence: true, length: { minimum: 3, maximum: 512 }

  default_scope { order(created_at: :desc) }

  paginates_per ENV['DEFAULT_PAGE_SIZE'].to_i

  before_validation :original_index, :format_original_index

  def format_original_index
    self.original_index = self.original_index.to_i unless self.original_index.is_a? Integer
  end

  def reindex_async
    PromptIndexerWorker.perform_async(self.id)
  end

end
