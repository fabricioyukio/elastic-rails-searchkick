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
  paginates_per Rails.env.default_page_size || 20
  validates :original_index, presence: true, integer: true
  validates :content, presence: true, length: { minimum: 3, maximum: 512 }

  searchkick callbacks: false

  default_scope { order(created_at: :desc) }

  def search_data
    {
      content: content
    }
  end

end
