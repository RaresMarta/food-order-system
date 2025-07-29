Rails.application.routes.draw do
  root "home#index"
  get "dashboard", to: "dashboard#index", as: :dashboard
  get "up" => "rails/health#show", as: :rails_health_check
end
