class FoodItem < ApplicationRecord
  has_one_attached :image

  scope :filter_by_category, ->(cat) {
    where(category: cat) if cat.present? && cat != "default"
  }

  scope :vegetarian_only, ->(veg) {
    where(vegetarian: ActiveModel::Type::Boolean.new.cast(veg)) if veg.present?
  }

  scope :price_between, ->(min, max) {
    min_val = min.present? ? min.to_f : 0
    max_val = max.present? ? max.to_f : 100
    where(price: min_val..max_val) if min_val <= max_val
  }

  scope :sorted_by_price, ->(order) {
    order(price: order.to_sym) if %w[asc desc].include?(order)
  }

  def self.filtered(params)
    Rails.logger.info "Filtering with params: #{params.inspect}"

    result = FoodItem.all
    result = result.filter_by_category(params[:category]) if params[:category].present?
    result = result.vegetarian_only(params[:vegetarian]) if params[:vegetarian].present?
    result = result.price_between(params[:min], params[:max]) if params[:min].present? || params[:max].present?
    result = result.sorted_by_price(params[:sort]) if params[:sort].present? && params[:sort] != "default"

    Rails.logger.info "Filtered result count: #{result.count}"
    result
  end
end
