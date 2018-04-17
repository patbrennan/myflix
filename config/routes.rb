Myflix::Application.routes.draw do
  root "videos#front"
  get 'ui(/:action)', controller: 'ui'
  get "/home", to: "videos#index"
  get "/register", to: "users#new"

  # These resources simulate logging in / out
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  get "/logout", to: "sessions#destroy"

  get "/my-queue", to: "q_items#index", as: "my_queue"

  resources :videos, only: [:index, :show] do
    collection do
      get "/search", to: "videos#search"
      get "/recent", to: "categories#recent"
    end

    member do
      resources :categories, only: [:show]
    end

    resources :reviews, only: [:create]
  end

  resources :users, only: [:new, :create, :edit, :update]
end
