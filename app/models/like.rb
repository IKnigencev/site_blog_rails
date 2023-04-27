# frozen_string_literal: true

class Like < ApplicationRecord
  belongs_to :user
  belongs_to :post, optional: true
  belongs_to :comment, optional: true

  # ##
  # # Колличество лайков у юзера
  # def post_count(user:)
  #   self.user
  #   where(user_id: user.id).count
  # end

  # ##
  # # Колличество лайков у юзера
  # def post_count(user:)
  #   self.user
  #   where(user_id: user.id).count
  # end
end
