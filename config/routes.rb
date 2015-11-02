Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  root "movies#index"

  devise_for :users

  resources :movies
  resources :categories
  resources :requests
end
