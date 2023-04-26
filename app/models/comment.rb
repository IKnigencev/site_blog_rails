# frozen_string_literal: true

class Comment < ApplicationRecord
  belongs_to :posts
  belongs_to :user

  ##
  # Автор комментария
  def author
    self.user
  end
end
