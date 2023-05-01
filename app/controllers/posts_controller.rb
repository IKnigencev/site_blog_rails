# frozen_string_literal: true

class PostsController < ApplicationController
  before_action :authenticate_user!, only: %i[edit update new create destory]
  before_action :set_post, only: %i[edit show destroy update]
  before_action :set_pagination, only: :index

  ##
  # GET /
  def index
    @posts = PostsServices.new(
      user: current_user,
      data: data_for_index
    ).posts_for_index
  end

  ##
  # GET /:id
  def show
    return not_found if @post.blank?

    return unless current_user.present?

    PostsServices.new(
      user: current_user,
      post: @post
    ).show
  end

  ##
  # GET /new
  def new
    @post = Post.new
  end

  ##
  # GET /:id/edit
  def edit
    render :new
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
      data: create_params,
      post: @post
    ).update_post
    if service.success?
      flash[:notice] = service.value!
      redirect_to url_for(controller: :posts, action: :show, id: @post.id)
    else
      flash[:alert] = service.failure[:error]
      render :new, status: :unprocessable_entity
    end
  end

  ##
  # DELETE /:id
  def destroy
    redirect_to action: "show", id: @post.id && return unless current_user == @post.author

    @post.destroy!
    redirect_to action: "index"
  end

  private
    ##
    # Пагинация постов на главной странице
    def set_pagination
      @page = params[:page].to_i || 0
      @prev_page = @page.present? && @page != 0 ? @page - 1 : 0
      @next_page = @page.present? ? @page + 1 : 0
    end

    ##
    # Поиск поста по id
    def set_post
      @post ||= Post.find_by(id: params[:id])
      return not_found if @post.blank?
    end

    ##
    # Данные для создания поста
    def create_params
      params.require(:post).permit(:text, :title, :image)
    end

    ##
    # Подготовка данных для сервиса
    def data_for_index
      {
        filter: params[:filter],
        page: @page
      }
    end
end
