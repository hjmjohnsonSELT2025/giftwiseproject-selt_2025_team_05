Rails.application.routes.draw do
  # source for devise configuration: https://medium.com/@sakatia.lise/how-to-customize-user-authentication-with-devise-and-rails-beginner-friendly-tutorial-a6b14ca79fb3
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  resources :events do
    resources :event_users, only: [:create, :update]
  end

  devise_scope :user do
    get '/users/show' => 'users/registrations#show', as: 'user_show'
  end

  #check app health
  get "/up", to: proc { [200, {}, ["OK"]] }

  resources :preferences do
    post :create_on_wishlist, on: :collection
    get 'view_user_wishlist/:user_id', to: 'preferences#view_user_wishlist', on: :collection, as: :view_user_wishlist
    post 'claim_preference', to: 'preferences#claim_preference', on: :collection, as: :claim_preference
  end

  resources :friendships, only: [:index, :new, :create, :update, :destroy]


  root to: "home#index"
end
