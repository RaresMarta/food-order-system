class FoodItem < ApplicationRecord
  has_one_attached :image

  scope :filter_by_category, ->(cat) {
    where(category: cat) if cat.present? && cat != "default"
  }

  scope :vegetarian_only, ->(veg) {
    where(vegetarian: ActiveModel::Type::Boolean.new.cast(veg)) if veg.present?
  }

  scope :price_between, ->(min, max) {
    where(price: (min || 0)..(max || 100))
  }

  scope :sorted_by_price, ->(order) {
    order(price: order.to_sym) if %w[asc desc].include?(order)
  }

  def self.filtered(params)
    FoodItem
      .filter_by_category(params[:category])
      .vegetarian_only(params[:vegetarian])
      .price_between(params[:min], params[:max])
      .sorted_by_price(params[:sort])
  end
end
