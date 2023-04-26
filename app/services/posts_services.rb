# frozen_string_literal: true

class PostsServices
  include Dry::Monads[:result]
  extend Dry::Initializer
  option :user
  option :data

  def show
    return if data.author == user

    data.increment!(:views)
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

  private
    ##
    # Валидности данных
    def validate_data
      @post.assign_attributes(user: user, **data)
      return if @post.valid?

      Failure.new({ error: @post.errors.messages })
    end
end
