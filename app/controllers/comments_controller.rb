# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post
  before_action :set_comment, only: %i[destroy edit update]

  ##
  # POST /:post_id/comments
  def create
    @comment = @post.comments.new(user: current_user, **create_comment)
    if @comment.valid?
      @comment.save!
      redirect_to_post 
    else
      flash[:alert] = @comment.errors.messages
      redirect_to_post 
    end
  end

  ##
  # DELETE /:post_id/comments/:id
  def destroy
    redirect_to_post && return unless @comment.author == current_user

    @comment.destroy
    redirect_to_post
  end

  ##
  # GET /:post_id/comments/:id
  def edit
    render template: "posts/show", locales: { post: @post, comment: @comment }
  end

  ##
  # PATCH /:post_id/comments/:id
  def update
    redirect_to_post && return unless @comment.author == current_user

    @comment.assign_attributes(**create_comment)
    redirect_to_post && return unless @comment.valid?

    @comment.save!
    redirect_to_post
  end

  private
    def set_post
      @post ||= Post.find_by(id: params[:post_id])
      return not_found if @post.blank?
    end
    
    def set_comment
      @comment ||= @post.comments.find_by(id: params[:id])
      return not_found if @comment.blank?
    end

    def create_comment
      params.require(:comment).permit(:text)
    end

    def redirect_to_post
      redirect_to show_posts_path(@post.id)
    end
end
