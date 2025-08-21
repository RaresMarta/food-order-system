Rails.application.routes.draw do
  devise_for :users
  use_doorkeeper

  root "food_items#index"

  # API routes
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      devise_scope :user do
        post "users", to: "registrations#create"
      end

      get  "auth/me",     to: "auth#me"
      post "auth/logout", to: "auth#logout"

      resources :food_items, only: [:index, :show]
      resources :orders, only: [:index, :show, :create, :update]
      resources :cart_items, only: [:index, :create, :update, :destroy]

      namespace :admin do
        resources :food_items, only: [:create, :update, :destroy] do
          member { patch :reactivate }
        end

        get "dashboard", to: "dashboard#index"
        get "dashboard/orders", to: "dashboard#orders"
        get "dashboard/menu", to: "dashboard#menu"
      end
    end
  end

  # Web routes
  resources :cart_items, only: [ :index, :create, :update, :destroy ]
  get "/cart", to: "cart_items#index", as: :cart

  resources :food_items, only: [ :create, :update, :destroy ]

  resources :orders, only: [ :index, :show, :create, :update ]

  get "/dashboard", to: "dashboard#index", as: :dashboard
  get "/dashboard/orders", to: "dashboard#orders", as: :dashboard_orders
  get "/dashboard/menu", to: "dashboard#menu", as: :dashboard_menu
end
