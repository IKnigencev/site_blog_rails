# frozen_string_literal: true

require "rails_helper"

RSpec.describe CommentsController, type: :controller do
  let(:user) { create(:user) }
  let(:user_post) { create(:post, user:) }
  let(:user_comment) { create(:comment, user:, post: user_post) }
  let(:comment) { create(:comment, post: user_post) }

  before do
    sign_in user
  end

  describe "#edit" do
    it "если передан не верный id юзера вернет 404" do
      expect do
        get :edit,
            params: { post_id: rand(1_000..2_000), id: rand(1_000..2_000) }
      end.to raise_error(ActionController::RoutingError)
    end

    it "если верно передан id юзера вернет статус 200" do
      get :edit, params: { post_id: user_post.id, id: comment.id }
      expect(response.status).to eq(200)
    end
  end

  describe "#create" do
    context "положительный сценарий" do
      it "при верных данных вернет 302" do
        post :create, params: success_data
        expect(response.status).to eq(302)
      end

      it "создаст комментарий" do
        post :create, params: success_data
        expect(Comment.where(user:, post: user_post)).to be_present
      end
    end

    context "негативный сценарий" do
      it "при верных данных вернет 302" do
        post :create, params: { post_id: user_post.id, comment: { text: "" } }
        expect(response.status).to eq(302)
      end

      it "не создаст комментарий" do
        post :create, params: { post_id: user_post.id, comment: { text: "" } }
        expect(Comment.where(user:, post: user_post, text: "")).to be_blank
      end
    end
  end

  describe "#update" do
    context "положительный сценарий" do
      it "при верных данных вернет 302" do
        patch :update, params: success_data
        expect(response.status).to eq(302)
      end

      it "обновит комментарий" do
        patch :update, params: success_data
        expect(
          Comment.find_by(
            user:,
            post: user_post
          ).text
        ).to eq(success_data[:comment][:text])
      end
    end

    context "негативный сценарий" do
      it "при неверных данных вернет 302" do
        patch :update, params: { post_id: user_post.id, id: user_comment.id, comment: { text: "" } }
        expect(response.status).to eq(302)
      end

      it "не обновит комментарий" do
        patch :update, params: { post_id: user_post.id, id: user_comment.id, comment: { text: "" } }
        expect(Comment.where(user:, post: user_post, text: success_data[:comment][:text])).to be_blank
      end
    end
  end

  describe "#destroy" do
    it "если передан не верный id юзера вернет 404" do
      expect do
        delete :destroy, params: { post_id: user_post.id, id: rand(1_000..2_000) }
      end.to raise_error(ActionController::RoutingError)
    end

    it "если верно передан id юзера вернет статус 302" do
      delete :destroy, params: success_data
      expect(response.status).to eq(302)
    end

    it "если верно передан id юзера удалит комментарий юзера" do
      delete :destroy, params: success_data
      expect(Comment.find_by(user:, post: user_post)).to be_blank
    end
  end

  def success_data
    {
      post_id: user_post.id,
      id: user_comment.id,
      comment: {
        text: "test_text"
      }
    }
  end
end
