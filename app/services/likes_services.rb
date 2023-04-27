# frozen_string_literal: true

##
# Класс работы c лайками
class LikesServices
  include Dry::Monads[:result]
  extend Dry::Initializer
  option :user
  option :post
  option :comment, optional: true, default: nil

  ##
  # Поставить/убрать лайк с поста
  def likes_post
    return create_like if like.new_record?

    destroy_like
  end
  
  ##
  # Поставить/убрать лайк с комментария
  def like_comment
    return create_like if like.new_record?

    destroy_like
  end

  private
    ##
    # Поиск или создание Like
    def like
      @like ||= if comment.present?
       Like.find_or_initialize_by(user: user, comment: comment)
      else
        Like.find_or_initialize_by(user: user, post: post)
      end
    end

    def create_like
      valid_res = validate_like
      return valid_res if valid_res.present?

      like.save!
      success
    end

    def destroy_like
      valid_res = validate_like
      return valid_res if valid_res.present?

      like.destroy!
      success
    end

    def validate_like
      return if like.valid?

      error
    end

    def success
      Success.new(message: I18n.t("likes.save.success"))
    end

    def error
      Failure.new({error: like.errors.messages })
    end
end
