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
      views_count: views_count,
      likes_count: likes_count,
      posts: posts,
      user: user
    }
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
      user.sum_likes
    end

    ##
    # Все посты юзера
    def posts
      user.posts
    end
end
