class Prompt < ApplicationRecord
  validates :content, presence: true, length: {
                                                minimum: 3,
                                                maximum: 512
                                              }

  default_scope -> { order(created_at: :desc) }
end
