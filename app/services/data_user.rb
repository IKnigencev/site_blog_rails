# frozen_string_literal: true

##
# Класс работы с данными юзера
class DataUser
  extend Dry::Initializer
  option :user

  ##
  # Данные пользователя
  def data
    {
      views_count:,
      likes_count:,
      posts:,
      user:
    }
  end

  ##
  # Список всех авторов с постами
  def authors_profile
    User.where.not(posts: { user_id: user.id }).with_posts
  end

  private
    ##
    # Колличество просмотров
    def views_count
      user.sum_views
    end

    ##
    # Колличество лайков
    def likes_count
      user.post_sum_likes
    end

    ##
    # Все посты юзера
    def posts
      user.posts.sort_by(&:created_at)
    end
end
