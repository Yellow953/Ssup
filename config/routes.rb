Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
  }
  get "/user/:id", to: "users#show", as: "user"

  resources :rooms do 
    resources :messages
  end
  
  root "rooms#index" 
end