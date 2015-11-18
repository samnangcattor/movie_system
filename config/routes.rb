Rails.application.routes.draw do
  mount RailsAdmin::Engine => "/admin", as: "rails_admin"
  mount Soulmate::Server, at: "/autocomplete"

  root "movies#index"

  devise_for :users

  resources :movies
  resources :categories
  resources :requests

  namespace :admin do
    resources :users
  end
end
