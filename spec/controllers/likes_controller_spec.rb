# frozen_string_literal: true

require "rails_helper"

RSpec.describe LikesController, type: :controller do
  let(:user) { create(:user) }
  let(:user_post) { create(:post, user:) }
  let(:comment) { create(:comment, user:, post: user_post) }
  let(:other_comment) { create(:comment, user:) }

  before do
    sign_in user
  end

  describe "#likes_post" do
    context "положительный сценарий" do
      it "при верных данных вернет 302" do
        post :likes_post, params: success_data
        expect(response.status).to eq(302)
      end

      it "создаст комментарий" do
        post :likes_post, params: success_data
        expect(Like.where(user:, post: user_post)).to be_present
      end
    end

    context "негативный сценарий" do
      it "при верных данных вернет 404" do
        expect do
          post :likes_post,
               params: { post_id: rand(0...comment.id) }
        end.to raise_error(ActionController::RoutingError)
      end
    end
  end

  describe "#likes_comment" do
    context "положительный сценарий" do
      it "при верных данных вернет 302" do
        post :likes_comment, params: success_data
        expect(response.status).to eq(302)
      end

      it "создаст лайк" do
        post :likes_comment, params: success_data
        expect(Like.where(user:)).to be_present
      end
    end

    context "негативный сценарий" do
      it "при верных данных вернет 404" do
        expect { post :likes_comment, params: incurrect_data }.to raise_error(ActionController::RoutingError)
      end
    end
  end

  def success_data
    {
      post_id: user_post.id,
      id: comment.id
    }
  end

  def incurrect_data
    {
      post_id: user_post.id,
      id: other_comment.id
    }
  end
end
