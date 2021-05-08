require "sidekiq/web"
require "sidekiq_auth"

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq", constraints: SidekiqAuth.new

  root to: "home#index"

  # resources :follows

  resources :artists do
    resources :follows, module: :artists
    collection do
      resources :follows, module: :artists, only: %i[new create]
    end
  end

  get "/hehe", to: "users#new"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  resources :users, only: %i[new create]
  # resources :artists
end
