Rails.application.routes.draw do
  devise_for :users
  resources :posts, path: "/", except: :show do
    resources :comments, except: :new
  end
  post "/:post_id/comments/:id/likes", to: "comments#increment_likes", as: :increment_likes_comment
  get "posts/:id", to: "posts#show", as: :show_post

  get "info/about", to: "info#about"
  get "info/contact", to: "info#contact"

  resources :profile, only: %i[show index]
end
