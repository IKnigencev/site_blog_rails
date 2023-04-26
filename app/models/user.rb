# frozen_string_literal: true

class User < Core::User
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :posts
  has_many :comments
  validates :email, uniqueness: true
  scope :with_posts, -> { joins(:posts).where.not(posts: { id: nil }).uniq }
  
  ##
  # Сумма просмотров
  def sum_views
    return if posts.blank?
 
    posts.select(:views).sum(:views)
  end

  ##
  # Сумма лайков
  def sum_likes
    return if posts.blank?

    posts.select(:likes).sum(:likes)
  end
end
