Rails.application.routes.draw do
  resources :users
  root :to => redirect('/users')

  resources :preferences, only: [:new, :create, :index]
end
