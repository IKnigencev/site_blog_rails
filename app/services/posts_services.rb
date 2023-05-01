# frozen_string_literal: true

class PostsServices
  include Dry::Monads[:result]
  extend Dry::Initializer
  option :user
  option :data, optional: true, default: nil
  option :post, optional: true, default: nil

  FILTER_DATA = {
    by_user: :user_id
  }.freeze
  PAGE_PAGINATION = 10

  ##
  # Обновление просмотров
  def show
    return if post.author == user

    @view = View.find_or_initialize_by(user:, post:)
    return unless @view.new_record?

    @view.save!
  end

  ##
  # Создание поста
  def create_post
    @post = Post.new
    res_valid = validate_data
    return res_valid if res_valid.is_a?(Failure)

    @post.save!
    Success.new(
      message: I18n.t("post.success_create")
    )
  end

  ##
  # Обновление поста
  def update_post
    res_valid = validate_data
    return res_valid if res_valid.is_a?(Failure)

    @post.save!
    Success.new(
      message: I18n.t("post.success_update")
    )
  end

  ##
  # Посты для главной страницы
  def posts_for_index
    @page = data[:page]
    return without_filter if user.blank?

    if data[:filter].present?
      filter_data(data[:filter])
    else
      without_filter
    end
  end

  private
    ##
    # Валидности данных
    def validate_data
      @post.assign_attributes(user:, **data)
      return if @post.valid?

      Failure.new({ error: @post.errors.messages })
    end

    ##
    # Стандартная выдача без фильтров
    def without_filter
      Post.order(created_at: :desc).limit(PAGE_PAGINATION).offset(@page * PAGE_PAGINATION)
    end

    ##
    # Данные с фильтром
    def filter_data(filter_type)
      return without_filter unless filter_type == "by_user"

      Post.where(
        user_id: user.id
      ).order(created_at: :desc).limit(PAGE_PAGINATION).offset(@page * PAGE_PAGINATION)
    end
end
