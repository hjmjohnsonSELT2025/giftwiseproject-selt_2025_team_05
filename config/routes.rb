Rails.application.routes.draw do
  # source for devise configuration: https://medium.com/@sakatia.lise/how-to-customize-user-authentication-with-devise-and-rails-beginner-friendly-tutorial-a6b14ca79fb3
  devise_for :users, controllers: {
    registrations: "users/registrations"
  }

  resources :events

  resources :preferences

  resources :friendships, only: [:create, :update, :destroy] #create->send friend request, update->accept/decline, destroy->delete

  root to: "home#index"
end
