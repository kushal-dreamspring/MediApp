Rails.application.routes.draw do
  resources :appointments
  resources :users
  resources :doctors
  root "doctors#index"
end
