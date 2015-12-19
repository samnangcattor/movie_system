Rails.application.routes.draw do
  mount RailsAdmin::Engine => "/admin", as: "rails_admin"

  root "movies#index"

  devise_for :users, only: :session

  resources :movies, only: [:index, :show]
  resources :categories, only: :show
  resources :requests, only: [:new, :create, :show]
  resources :years, only: :show

  namespace :admin do
    resources :users
  end
end
