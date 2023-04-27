Rails.application.routes.draw do
  get "posts/:id", to: "posts#show", as: :show_posts
  devise_for :users
  resources :posts, path: "/", except: :show do
    resources :comments, except: :new
  end
  post "/:post_id/likes_post", to: "likes#likes_post", as: :like_posts
  post "/:post_id/comments/:id/likes", to: "likes#likes_comment", as: :like_comment


  get "info/about", to: "info#about"
  get "info/contact", to: "info#contact"

  resources :profile, only: %i[show index]
end
