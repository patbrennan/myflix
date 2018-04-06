Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  get "/home", to: "videos#index"
  # get "/videos/:id", to: "video#show", as: :show_videos
  # get "/videos/categories/:id", to: "category#show", as: :show_video_categories

  resources :videos, only: [:index, :show] do
    collection do
      get "/search", to: "videos#search"
      get "/recent", to: "categories#recent"
    end

    member do
      resources :categories, only: [:show]
    end
  end
end
