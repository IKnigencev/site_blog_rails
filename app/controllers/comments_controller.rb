# frozen_string_literal: true

class CommentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post
  before_action :set_comment, only: :destroy

  ##
  # POST /:post_id/comments
  def create
    @comment = @post.comments.new(user: current_user, **create_comment)
    if @comment.valid?
      @comment.save!
      redirect_to show_posts_path(@post.id) 
    else
      flash[:alert] = @comment.errors.messages
      redirect_to show_posts_path(@post.id) 
    end
  end

  ##
  # DELETE /:post_id/comments/:id
  def destroy
    redirect_to show_posts_path(@post.id) && return unless @comment.author == current_user

    @comment.destroy
    redirect_to show_posts_path(@post.id)
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
end
