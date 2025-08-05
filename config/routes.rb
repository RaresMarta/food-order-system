Rails.application.routes.draw do
  root "home#index"

  get "/register", to: "users#new"
  post "/register", to: "users#create"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  get "/cart", to: "cart#show", as: :cart
  resources :cart_items, only: [ :create, :update, :destroy ]

  get "/dashboard", to: "dashboard#index", as: :dashboard
  resources :food_items, only: [ :create, :update, :destroy ]
end
