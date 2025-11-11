Rails.application.routes.draw do
  root 'sessions#home'

  resources :users
  resources :sessions


  post '/login', to: 'sessions#create'

  get '/signup', to: 'users#new'

end
