# frozen_string_literal: true

require "rails_helper"

RSpec.describe DataUser do
  let(:user) { create(:user) }

  before do
    create_list(:post, rand(2..5), user:)
  end

  describe "#authors_profile" do
    before do
      create_list(:user, rand(2..5))
      other_author = create(:user)
      create(:post, user: user)
    end

    it "вернет список юзеров у которых есть посты" do
      res = DataUser.new(user: user).authors_profile
      expect(res).to eq(authors_list)
    end
  end

  it "вернет верные данные юзера" do
    expect(
      described_class.new(user:).data
    ).to eq(res_field)
  end

  def authors_list
    User.where.not(posts: { user_id: user.id }).with_posts
  end

  def res_field
    {
      views_count: user.sum_views,
      likes_count: user.post_sum_likes,
      posts: user.posts.sort_by(&:created_at),
      user:
    }
  end
end
