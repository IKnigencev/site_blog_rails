# frozen_string_literal: true

require "rails_helper"

RSpec.describe PostsController, type: :controller do
  let(:user) { create(:user) }
  let(:user_post) { create(:post, user: user) }
	let(:post) { create(:post) }

  before do
    sign_in user
  end

  describe "#index" do
    it "вернет статус 200" do
      get :index
      expect(response.status).to eq(200)
    end
  end

	describe "#new" do
    it "вернет статус 200" do
      get :new
      expect(response.status).to eq(200)
    end
  end

  describe "#show" do
    it "если передан не верный id юзера вернет 404" do
      expect { get :show, params: { id: rand(1_000..2_000) } }.to raise_error(ActionController::RoutingError)
    end

    it "если верно передан id юзера вернет статус 200" do
      get :show, params: { id: post.id }
      expect(response.status).to eq(200)
    end

    it "создаст просмотр, если current_user не автор поста" do
      expect { get :show, params: { id: post.id } }.to change { View.exists?(post_id: post.id) }.from(false).to(true)
    end

    it "не создаст просмотр, если current_user автор поста" do
      get :show, params: { id: user_post.id } 
      expect(View.exists?(post_id: user_post.id)).to be_falsey
    end
  end

  describe "#edit" do
    it "если передан не верный id юзера вернет 404" do
      expect { get :edit, params: { id: rand(1_000..2_000) } }.to raise_error(ActionController::RoutingError)
    end

    it "если верно передан id юзера вернет статус 200" do
      get :edit, params: { id: post.id }
      expect(response.status).to eq(200)
    end
  end

  describe "#create" do
    context "положительный сценарий" do
      it "при верных данных вернет 200" do
        post :create, params: success_data
        expect(response.status).to eq(200)
      end

      it "создаст пост" do
        post :create, params: success_data
        expect(Post.where(user: user, **success_data)).to be_present
      end
    end

    context "негативный сценарий" do
      it "при верных данных вернет 422" do
        post :create, params: { title: "", text: "" }
        expect(response.status).to eq(422)
      end

      it "не создаст пост" do
        expect { post :create, params: { title: "", text: "" } }.to change { Post.where(user: user, **success_data).present? }.from(false).to(false)
      end
    end
  end

  def success_data
    {
      title: "test_title",
      text: "text_title"
    }
  end
end
