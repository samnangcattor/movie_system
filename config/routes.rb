require "sidekiq/web"
Rails.application.routes.draw do
  get "/oauth2callback", to: "movies#update"
  mount RailsAdmin::Engine => "/adminmviehdkh", as: "rails_admin"

  root "movies#index"

  devise_for :users, only: :session, path: "", path_names: {sign_in: "@dminmoviehdkhlog_in"}

  resources :movies, only: [:index, :show]
  resources :categories, only: :show
  resources :requests, only: [:new, :create, :show]
  resources :years, only: :show

  namespace :admin do
    resources :users
  end
  mount Sidekiq::Web, at: "/moviehdkh@sidekiq"
end
