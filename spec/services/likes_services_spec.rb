# frozen_string_literal: true

require "rails_helper"

RSpec.describe LikesServices do
  let(:user) { create(:user) }

  before do
    @post = create(:post, user:)
  end

  describe "#like_comment" do
    before do
      @comment = create(:comment, user:, post: @post)
      described_class.new(
        user:, post: @post, comment: @comment
      ).like_comment
    end

    it "создаст новый дайк если еще не было" do
      expect(
        Like.where(user:, comment: @comment)
      ).to be_present
    end

    it "удалит лайк если уже был" do
      described_class.new(
        user:, post: @post, comment: @comment
      ).like_comment
      expect(
        Like.where(user:, comment: @comment)
      ).to be_blank
    end
  end

  describe "#likes_post" do
    before do
      described_class.new(
        user:, post: @post
      ).likes_post
    end

    it "создаст новый дайк если еще не было" do
      expect(
        Like.where(user:, post: @post)
      ).to be_present
    end

    it "удалит лайк если уже был" do
      described_class.new(
        user:, post: @post
      ).likes_post
      expect(
        Like.where(user:, post: @post)
      ).to be_blank
    end
  end
end
