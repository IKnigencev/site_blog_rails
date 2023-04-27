# frozen_string_literal: true

class LikesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post
  before_action :set_comment, only: :likes_comment

  ##
  # POST /:post_id/likes
  def likes_post
    service = LikesServices.new(
      user: current_user,
      post: @post
    ).likes_post
    puts show_posts_path(@post.id)
    if service.success?
      render show_posts_path(@post.id), status: :created
    else
      render show_posts_path(@post.id), status: :not_found 
    end
  end

  ##
  # POST /:post_id/comments/:id/likes
  def likes_comment
    service = LikesServices.new(
      user: current_user,
      post: @post,
      comment: @comment
    ).like_comment
    if service.success?
      render show_posts_path(@post.id), status: :created
    else
      render show_posts_path(@post.id), status: :not_found  
    end
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
end
