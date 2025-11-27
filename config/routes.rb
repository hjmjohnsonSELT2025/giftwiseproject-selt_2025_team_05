Rails.application.routes.draw do
  # source for devise configuration: https://medium.com/@sakatia.lise/how-to-customize-user-authentication-with-devise-and-rails-beginner-friendly-tutorial-a6b14ca79fb3
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  resources :events do
    resources :event_users, only: [:create, :update, :show] do
      get :gift_suggestions, to: "gift_suggestions#show"
      post :gift_suggestions, to: "gift_suggestions#create"
    end
  end

  devise_scope :user do
    get '/users/show' => 'users/registrations#show', as: 'user_show'
  end

  #check app health
  get "/up", to: proc { [200, {}, ["OK"]] }

  resources :preferences do
    post :create_on_wishlist, on: :collection
  end

  resources :friendships, only: [:index, :new, :create, :update, :destroy]


  root to: "home#index"
end
