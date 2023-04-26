# frozen_string_literal: true

class Post < ApplicationRecord
  belongs_to :user
  has_one_attached :image
  has_many :comments
  validates_presence_of :title, :text
  validate :image_valid, if: proc { image.present? }

  ACCESS_FILE_TYPE = %w[
    image/jpeg
    image/png
    image/jpg
  ].freeze

  ##
  # Автор поста
  def author
    self.user
  end

  private
    ##
    # Проверка типа файла
    def image_valid
      return if ACCESS_FILE_TYPE.include?(image.content_type)

      errors.add(:iamge, I18n.t("post.errors.content_type"))
    end
end
