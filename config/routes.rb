Rails.application.routes.draw do
  root "home#index"

  get "/register", to: "users#new"
  post "/register", to: "users#create"
  get "/login", to: "sessions#new"
  post "/login", to: "sessions#create"
  delete "/logout", to: "sessions#destroy"

  resources :cart_items, only: [ :index, :create, :update, :destroy ]
  get "/cart", to: "cart_items#index", as: :cart

  get "/dashboard", to: "dashboard#index", as: :dashboard
  resources :food_items, only: [ :create, :update, :destroy ]
end
