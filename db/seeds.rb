require "factory_bot_rails"

def create_admin_user
  AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
end

def create_test_user
  user = User.create!(email: "test@mail.ru", password: "test_password")
  posts = FactoryBot.create_list(:post, rand(2..10), user: user)
  FactoryBot.create_list(:comment, rand(2..5), post: posts.sample)
end

def create_other_users_and_posts
  FactoryBot.create_list(:user, rand(2..10)).each do |user|
    posts = FactoryBot.create_list(:post, rand(2..10), user: user)
    FactoryBot.create_list(:comment, rand(2..5), post: posts.sample)
  end
end

unless Rails.env.production?
  create_test_user
  create_other_users_and_posts
  create_admin_user
end
