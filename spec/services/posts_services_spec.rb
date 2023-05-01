# frozen_string_literal: true

require "rails_helper"

RSpec.describe PostsServices do
  let(:user) { create(:user) }

  describe "#show" do
    before do
      @other_user = create(:user)
      @post = create(:post, user:)
    end

    it "не добавит просмотров если автор" do
      described_class.new(user:, post: @post).show
      expect(View.find_by(user:)).to be_blank
    end

    it "добавит просмотров если не автор" do
      described_class.new(user: @other_user, post: @post).show
      expect(View.find_by(user: @other_user)).to be_present
    end

    it "добавит только один просмотр если не автор" do
      described_class.new(user: @other_user, post: @post).show
      described_class.new(user: @other_user, post: @post).show
      expect(View.where(user: @other_user).count).to eq(1)
    end
  end

  describe "#create_post" do
    context "положительный сценарий" do
      before do
        @res = described_class.new(
          user:,
          data: success_data
        ).create_post
      end

      it "вернет success ответ" do
        expect(@res).to be_success
      end

      it "вернет верный текст" do
        expect(@res.value![:message]).to eq(I18n.t("post.success_create"))
      end

      it "создаст пост" do
        expect(Post.find_by(user_id: user.id)).to be_present
      end
    end

    context "негативный сценарий" do
      it "при пустых полях выдаст ошибку" do
        res = described_class.new(
          user:,
          data: { title: "", text: "" }
        ).create_post
        expect(res).to be_failure
      end
    end
  end

  describe "#update_post" do
    context "положительный сценарий" do
      before do
        @post = create(:post, user:)
        @res = described_class.new(
          user:,
          data: success_data,
          post: @post
        ).update_post
      end

      it "вернет верный текст" do
        expect(@res.value![:message]).to eq(I18n.t("post.success_update"))
      end

      it "вернет success ответ" do
        expect(@res).to be_success
      end

      it "изменит данные поста" do
        expect(
          @post.attributes.slice(*success_data.deep_stringify_keys.keys)
        ).to eq(success_data.deep_stringify_keys)
      end
    end

    context "негативный сценарий" do
      before do
        @post = create(:post, user:)
      end

      it "при пустых полях выдаст ошибку" do
        res = described_class.new(
          user:,
          data: { title: "", text: "" },
          post: @post
        ).update_post
        expect(res).to be_failure
      end
    end
  end

  describe "#posts_for_index" do
    before do
      create_list(:post, rand(10..15), user:)
      create_list(:post, rand(10..15))
      data = { page: 0 }
      @res_filter = described_class.new(
        user:,
        data: { page: 0, filter: "by_user" }
      ).posts_for_index
      @res_without = described_class.new(
        user:,
        data: { page: 0 }
      ).posts_for_index
    end

    it "вернет только 10 постов c фильтром" do
      expect(@res_filter.count).to eq(10)
    end

    it "вернет только 10 постов без фильтром" do
      expect(@res_without.count).to eq(10)
    end

    it "вернет только записи юзера" do
      expect(@res_filter).to eq(filter_data)
    end

    it "если не указан фильтр вернет все посты" do
      res = described_class.new(
        user:,
        data: { page: 0, filter: nil }
      ).posts_for_index
      expect(res).to eq(without_filter)
    end

    it "если не указан юзер вернет все посты" do
      res = described_class.new(
        user: nil,
        data: { page: 0 }
      ).posts_for_index
      expect(res).to eq(without_filter)
    end
  end

  def success_data
    {
      title: "test_title",
      text: "test_text"
    }
  end

  def without_filter
    Post.order(
      created_at: :desc
    ).limit(
      described_class::PAGE_PAGINATION
    ).offset(0 * described_class::PAGE_PAGINATION)
  end

  def filter_data
    Post.where(
      user_id: user.id
    ).order(
      created_at: :desc
    ).limit(
      described_class::PAGE_PAGINATION
    ).offset(0 * described_class::PAGE_PAGINATION)
  end
end
