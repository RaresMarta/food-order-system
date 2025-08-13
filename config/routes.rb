Rails.application.routes.draw do
  root "food_items#index"

  get "/register", to: "users#new"
  post "/register", to: "users#create"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  resources :cart_items, only: [ :index, :create, :update, :destroy ]
  get "/cart", to: "cart_items#index", as: :cart

  resources :food_items, only: [ :create, :update, :destroy ]

  resources :orders, only: [ :index, :show, :create ]

  get "/dashboard", to: "dashboard#index", as: :dashboard
end
