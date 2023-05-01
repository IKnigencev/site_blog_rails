require 'faker'

data = [
  {
    user: { email: "test@mail.ru", password: "test_password" },
    posts: [
      { title: "test_title", text: "test_text" }
    ],
    comments: {}
  },
  {
    user: {},
  },
]

if Rails.env.development?
  AdminUser.create!(email: 'admin@example.com', password: 'password', password_confirmation: 'password')
end

def create_test_user
  user = User.create!(email: "test@mail.ru", password: "test_password")
  Post.insert_all(test_user_posts)
end

def create_other_users

end

def create_data
  data_for_user.each do |user|
    user = User.create!(**user)
  end
end

# unless Rails.env.production?
#   create_test_user
#   create_other_users
#   create_data
# end
