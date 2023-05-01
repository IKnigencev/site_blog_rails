# frozen_string_literal: true

require "rails_helper"

RSpec.describe PostsController, type: :controller do
  let(:user) { create(:user) }
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
  end
end
