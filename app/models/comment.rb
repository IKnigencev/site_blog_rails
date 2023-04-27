# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :post
  belongs_to :user
  validates :text, presence: true, length: { maximum: 300 }

  ##
  # Автор комментария
  def author
    self.user
  end
end
