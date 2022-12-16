Rails.application.routes.draw do
  devise_for :users
  resources :rooms

  devise_scope :user do
    get "users", to: "deviser/sessions#new"
  end
  get "/user/:id", to: "user#show", as: "user"

  root "rooms#index" 
end
