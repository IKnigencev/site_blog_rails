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
    return 0 if posts.blank?

    View.where(post_id: posts.pluck(:id)).where.not(user_id: nil).count
  end

  ##
  # Колличество лайков под постами юзера
  def post_sum_likes
    return 0 if posts.blank?

    Like.where(post_id: posts.pluck(:id)).where.not(user_id: nil).count
  end
end
