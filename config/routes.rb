Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  root "movies#index"

  devise_for :users

  resources :movies
  resources :categories
  resources :requests
end
