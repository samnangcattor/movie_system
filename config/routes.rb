require "sidekiq/web"
Rails.application.routes.draw do
  mount Resque::Server, :at => "/resque"
  get "/oauth2callback", to: "uploads#update"
  mount RailsAdmin::Engine => "/adminmviehdkh", as: "rails_admin"

  root "movies#index"

  devise_for :users, only: :session, path: "", path_names: {sign_in: "@dminmoviehdkhlog_in"}

  resources :movies, only: [:index, :show]
  resources :categories, only: :show
  resources :requests, only: [:new, :create, :show]
  resources :years, only: :show
  resources :advertises, only: :index
  resources :searchs, only: :index
  resources :uploads, only: [:index, :update]
  resources :links, only: :index

  namespace :admin do
    resources :users
    resources :torrents, only: :index
  end
end
