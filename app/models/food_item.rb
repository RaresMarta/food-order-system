class FoodItem < ApplicationRecord
  has_one_attached :image

  validates :name, presence: true, length: { maximum: 100 }
  validates :category, presence: true, length: { maximum: 50 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :vegetarian, inclusion: { in: [true, false] }

  scope :filter_by_category, ->(cat) {
    cat.present? && cat != "default" ? where(category: cat) : all
  }

  scope :vegetarian_only, ->(veg) {
    veg.present? ? where(vegetarian: ActiveModel::Type::Boolean.new.cast(veg)) : all
  }

  scope :price_between, ->(min, max) {
    min_val = min.present? ? min.to_f : 0
    max_val = max.present? ? max.to_f : 100
    min_val <= max_val ? where(price: min_val..max_val) : all
  }

  scope :sorted_by_price, ->(order) {
    %w[asc desc].include?(order) ? order(price: order.to_sym) : all
  }

  def self.filtered(params)
    FoodItem
      .filter_by_category(params[:category])
      .vegetarian_only(params[:vegetarian])
      .price_between(params[:min], params[:max])
      .sorted_by_price(params[:sort])
  end
end
