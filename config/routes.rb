Rails.application.routes.draw do
  devise_for :users
  # root 'home#index'

  devise_for :users, path: "", controllers: {
    sessions: "users/sessions",
    registrations: "users/registrations",
    passwords: "users/passwords"
  }, skip: %i[registrations]
  as :user do
    get "/sign_up", to: "users/registrations#new", as: :new_user_registration
  end

end
