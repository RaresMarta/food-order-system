Rails.application.routes.draw do
  devise_for :users
  root "food_items#index"

  resources :cart_items, only: [ :index, :create, :update, :destroy ]
  get "/cart", to: "cart_items#index", as: :cart

  resources :food_items, only: [ :create, :update, :destroy ]

  resources :orders, only: [ :index, :show, :create, :update ]

  get "/dashboard", to: "dashboard#index", as: :dashboard
  get "/dashboard/orders", to: "dashboard#orders", as: :dashboard_orders
  get "/dashboard/menu", to: "dashboard#menu", as: :dashboard_menu
end
