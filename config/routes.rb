Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  mount Soulmate::Server, at: "/autocomplete"

  root "movies#index"

  devise_for :users

  resources :movies
  resources :categories
  resources :requests
end
