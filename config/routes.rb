Rails.application.routes.draw do
  # source for devise configuration: https://medium.com/@sakatia.lise/how-to-customize-user-authentication-with-devise-and-rails-beginner-friendly-tutorial-a6b14ca79fb3
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  resources :events do
    resources :event_users, only: [:create, :update, :show] do
      get :gift_suggestions, to: "gift_suggestions#show"
      post :gift_suggestions, to: "gift_suggestions#create"
      patch :update_budget
    end
  end

  devise_scope :user do
    get '/users/show' => 'users/registrations#show', as: 'user_show'
  end

  #check app health
  get "/up", to: proc { [200, {}, ["OK"]] }

  resources :preferences do
    get 'view_user_wishlist/:user_id/:event_id', to: 'preferences#view_user_wishlist', on: :collection, as: :view_user_wishlist #chatgpt helped generate the syntax for this custom route
    post 'claim_preference', to: 'preferences#claim_preference', on: :collection, as: :claim_preference
    post 'unclaim_preference_summary', to: 'preferences#unclaim_preference_summary', on: :collection, as: :unclaim_preference_summary
    post 'unclaim_preference', to: 'preferences#unclaim_preference', on: :collection, as: :unclaim_preference
    post 'unclaim_preference_wishlist', to: 'preferences#unclaim_preference_wishlist', on: :collection, as: :unclaim_preference_wishlist
    post 'unclaim_show_preference', to: 'preferences#unclaim_show_preference', on: :collection, as: :unclaim_show_preference
    post :toggle_purchase, on: :member
    post :toggle_purchase_show, on: :member

  end

  resources :friendships, only: [:index, :new, :create, :update, :destroy]

  resources :suggestions do
    post :toggle_purchase_suggestion, on: :member
    post :toggle_purchase_suggestion_show, on: :member
  end

  get '/user_gift_summary/:user_id/:event_id', to: 'user_gift_summary#show', as: :user_gift_summary
  get '/add_gift/:user_id/:event_id', to: 'user_gift_summary#add_gift', as: :add_gift

  root to: "home#index"
end
