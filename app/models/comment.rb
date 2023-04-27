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

  ##
  # Колличество лайков
  def likes
    Like.where(comment_id: self.id).count
  end
end
