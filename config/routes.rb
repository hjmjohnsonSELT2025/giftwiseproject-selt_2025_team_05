Rails.application.routes.draw do
  root 'sessions#home'

  resources :users
  resources :sessions

  get '/login', to: 'sessions#new' #login
  post '/login', to: 'sessions#create' #signup

end
