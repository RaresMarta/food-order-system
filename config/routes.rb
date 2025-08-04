Rails.application.routes.draw do
  root "home#index"
  get "dashboard", to: "dashboard#index", as: :dashboard
  resources :food_items, only: [ :index, :create, :update, :destroy ]
end
