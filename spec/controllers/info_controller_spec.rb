# frozen_string_literal: true

require "rails_helper"

RSpec.describe InfoController, type: :controller do

  describe "#contact" do
    it "вернет статус 200" do
      get :contact
      expect(response.status).to eq(200)
    end
  end

	describe "#about" do
    it "вернет статус 200" do
      get :about
      expect(response.status).to eq(200)
    end
  end
end
