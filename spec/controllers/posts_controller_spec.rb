# frozen_string_literal: true

require "rails_helper"

RSpec.describe PostsController, type: :controller do
  let(:user) { create(:user) }
  let(:user_post) { create(:post, user:) }
  let(:other_post) { create(:post) }

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
      get :show, params: { id: other_post.id }
      expect(response.status).to eq(200)
    end

    it "создаст просмотр, если current_user не автор поста" do
      expect { get :show, params: { id: other_post.id } }.to change {
                                                               View.exists?(post_id: other_post.id)
                                                             }.from(false).to(true)
    end

    it "не создаст просмотр, если current_user автор поста" do
      get :show, params: { id: user_post.id }
      expect(View.exists?(post_id: user_post.id)).to be_falsey
    end
  end

  describe "#edit" do
    it "если передан не верный id юзера вернет 404" do
      expect { get :edit, params: { id: "1" } }.to raise_error(ActionController::RoutingError)
    end

    it "если верно передан id юзера вернет статус 200" do
      get :edit, params: { id: other_post.id }
      expect(response.status).to eq(200)
    end
  end

  describe "#create" do
    context "положительный сценарий" do
      it "при верных данных вернет 201" do
        post :create, params: { post: success_data }
        expect(response.status).to eq(201)
      end

      it "создаст пост" do
        post :create, params: { post: success_data }
        expect(Post.where(user:, **success_data)).to be_present
      end
    end

    context "негативный сценарий" do
      it "при верных данных вернет 422" do
        post :create, params: { post: { title: "", text: "" } }
        expect(response.status).to eq(422)
      end

      it "не создаст пост" do
        post :create, params: { post: { title: "", text: "" } }
        expect(Post.where(user:, **success_data).present?).to be_falsey
      end
    end
  end

  describe "#update" do
    context "положительный сценарий" do
      it "при верных данных вернет 302" do
        patch :update, params: { id: user_post.id, post: success_data }
        expect(response.status).to eq(302)
      end

      it "обновит пост" do
        patch :update, params: { id: user_post.id, post: success_data }
        expect(
          Post.find_by(
            id: user_post.id
          ).attributes.slice("title", "text").deep_symbolize_keys
        ).to eq(success_data)
      end
    end

    context "негативный сценарий" do
      it "при неверных данных вернет 422" do
        patch :update, params: { id: user_post.id, post: { title: "", text: "" } }
        expect(response.status).to eq(422)
      end

      it "не обновит пост" do
        patch :update, params: { id: user_post.id, post: { title: "", text: "" } }
        expect(Post.where(user:, **success_data).present?).to be_falsey
      end
    end
  end

  describe "#destroy" do
    it "если передан не верный id юзера вернет 404" do
      expect do
        delete :destroy, params: { id: other_post.id }
      end.to raise_error(ActionController::RoutingError)
    end

    it "если верно передан id юзера вернет статус 302" do
      delete :destroy, params: { id: user_post.id }
      expect(response.status).to eq(302)
    end

    it "если верно передан id юзера удалит пост юзера" do
      delete :destroy, params: { id: user_post.id }
      expect(Post.find_by(user:)).to be_blank
    end
  end

  def success_data
    {
      title: "test_title",
      text: "text_title"
    }
  end
end
