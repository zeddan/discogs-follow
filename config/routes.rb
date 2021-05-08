require "sidekiq/web"
require "sidekiq_auth"

Rails.application.routes.draw do
  mount Sidekiq::Web => "/sidekiq", constraints: SidekiqAuth.new

  root to: "home#index"

  resources :artists do
    resources :follows, except: %i[new create], module: :artists
    collection do
      resources :follows,
                module: :artists,
                only: %i[new create],
                as: :custom_artist_follows
    end
  end

  resources :labels do
    resources :follows, except: %i[new create], module: :labels
    collection do
      resources :follows,
                module: :labels,
                only: %i[new create],
                as: :custom_labels_follows
    end
  end


  get "/hehe", to: "users#new"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  resources :users, only: %i[new create]
  # resources :artists
end
