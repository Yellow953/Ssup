Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations',
  }
  get "/user/:id", to: "users#show", as: "user"

  resources :rooms do 
    resources :messages
    collection do 
      post :search
    end
  end
  
  get "/rooms/leave/:id", to: "rooms#leave", as: "leave_room"
  get "/rooms/join/:id", to: "rooms#join", as: "join_room"

  root "rooms#index" 
end