class FoodItemSerializer < ApplicationSerializer
  attributes :id, :name, :category, :price, :vegetarian

  attribute :image_url do |food_item|
    food_item.image.attached? ? Rails.application.routes.url_helpers.url_for(food_item.image) : nil
  end
end
