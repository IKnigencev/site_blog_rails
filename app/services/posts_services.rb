# frozen_string_literal: true

class PostsServices
  include Dry::Monads[:result]
  extend Dry::Initializer
  option :user
  option :data, optional: true, default: nil
  option :post, optional: true, default: nil

  ##
  # Обновление просмотров
  def show
    return if post.author == user

    @view = View.find_or_initialize_by(user: user, post: post)
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

  private
    ##
    # Валидности данных
    def validate_data
      @post.assign_attributes(user: user, **data)
      return if @post.valid?

      Failure.new({ error: @post.errors.messages })
    end
end
