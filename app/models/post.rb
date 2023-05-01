# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :comments
  validates :title, :text, presence: true
  validates :title, length: { maximum: 150 }
  validates :text, length: { maximum: 10_000 }
  validate :image_valid, if: proc { image.present? }

  ACCESS_FILE_TYPE = %w[
    image/jpeg
    image/png
    image/jpg
  ].freeze

  ##
  # Автор поста
  def author
    user
  end

  ##
  # Колличество лайков
  def likes
    Like.where(post_id: id).count
  end

  ##
  # Коллиыество просмотров
  def views
    View.where(post_id: id).count
  end

  private
    ##
    # Проверка типа файла
    def image_valid
      return if ACCESS_FILE_TYPE.include?(image.content_type)

      errors.add(:iamge, I18n.t("post.errors.content_type"))
    end
end
