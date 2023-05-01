# == Schema Information
#
# Table name: prompts
# id             :bigint           not null, primary key
# original_index :bigint          default(0), not null

class Prompt < ApplicationRecord
  validates :content, presence: true, length: {
                                                minimum: 3,
                                                maximum: 512
                                              }

  default_scope -> { order(created_at: :desc) }

  searchkick

  def search_data
    {
      name: name,
      email: email,
      total_blogposts: blogposts.count,
      last_published_blogpost_date: last_published_blogpost_date
    }
  end
end
