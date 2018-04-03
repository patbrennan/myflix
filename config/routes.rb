Myflix::Application.routes.draw do
  get 'ui(/:action)', controller: 'ui'
  get "/home", to: "video#index"
  get "/videos/:id", to: "video#show", as: :show_videos
  get "/videos/categories/:id", to: "category#show", as: :show_video_categories
end
