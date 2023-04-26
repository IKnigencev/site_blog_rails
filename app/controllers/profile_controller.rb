# frozen_string_literal: true

class ProfileController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: :show

  ##
  # GET /profile
  def index
    @authors = User.with_posts
  end

  ##
  # GET /profile/:id
  def show
    @data = DataUser.new(user: @user).data
  end

  private
    def set_user
      @user ||= User.find_by(id: params[:id])
      return not_found if @user.blank?
    end
end
