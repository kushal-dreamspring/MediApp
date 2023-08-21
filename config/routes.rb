Rails.application.routes.draw do
  resources :appointments
  resources :users
  resources :doctors
  get '/login', to: 'users#new'
  post '/login', to: 'users#login'
  root 'doctors#index'
end
