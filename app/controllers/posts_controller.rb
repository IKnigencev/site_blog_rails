# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!, only: %i[edit update new create destory]
  before_action :set_post, only: %i[edit show destroy update]

  ##
  # GET /
  def index
    @posts = Post.all
  end

  ##
  # GET /:id
  def show
    return not_found if @post.blank?

    PostsServices.new(
      user: current_user,
      data: @post
    ).show
  end

  ##
  # GET /new
  def new
    @post = Post.new
  end

  ##
  # POST /
  def create
    service = PostsServices.new(
      user: current_user,
      data: create_params
    ).create_post
    if service.success?
      flash[:notice] = service.value!
      redirect_to posts_path, status: :created
    else
      flash[:alert] = service.failure[:error]
      @post = Post.new
      render :new, status: :unprocessable_entity
    end
  end

  ##
  # PATCH /:id
  def update
    service = PostsServices.new(
      user: current_user,
      data: create_params
    ).update_post
    if service.success?
      flash[:notice] = service.value!
      redirect_to posts_path, status: :created
    else
      flash[:alert] = service.failure[:error]
      @post = Post.new
      render :new, status: :unprocessable_entity
    end
  end

  ##
  # GET /:id/edit
  def edit
    render :new
  end

  ##
  # DELETE /:id
  def destroy
    head :forbidden && return unless current_user == @post.author

    @post.destory
    head :ok
  end

  private
    def set_post
      @post ||= Post.find_by(id: params[:id])
    end

    def create_params
      params.require(:post).permit(:text, :title, :image)
    end
end
