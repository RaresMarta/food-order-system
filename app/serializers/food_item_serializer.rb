class FoodItemSerializer < ApplicationSerializer
  attributes :id, :name, :category, :price, :vegetarian, :deleted, :deleted_at, :created_at, :updated_at

  attribute :image_url do |food_item|
    food_item.image.attached? ? Rails.application.routes.url_helpers.url_for(food_item.image) : nil
  end

  attribute :price do |food_item|
    food_item.price.to_f
  end

  attribute :deleted do |food_item|
    food_item.deleted?
  end
end
