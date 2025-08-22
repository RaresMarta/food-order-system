class FoodItem < ApplicationRecord
  has_many :order_items
  has_many :cart_items, dependent: :destroy
  has_many :users, through: :cart_items

  has_one_attached :image

  validates :name, presence: true, length: { maximum: 100 }
  validates :category, presence: true, length: { maximum: 50 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :vegetarian, inclusion: { in: [ true, false ] }

  scope :active, -> { where(deleted_at: nil) }

  scope :filter_by_category, ->(cat) {
    return all unless cat.present? && cat != "default"
    where(category: cat)
  }

  scope :vegetarian_only, ->(veg) {
    return all unless veg.present?
    where(vegetarian: ActiveModel::Type::Boolean.new.cast(veg))
  }

  scope :price_between, ->(min, max) {
    min_val = min.present? ? min.to_f : -Float::INFINITY
    max_val = max.present? ? max.to_f :  Float::INFINITY
    where(price: min_val..max_val)
  }

  scope :sorted_by_price, ->(order) {
    return all unless %w[asc desc].include?(order)
    order(price: order.to_sym)
  }

  def soft_delete!
    update(deleted_at: Time.current)
  end

  def deleted?
    deleted_at.present?
  end
end
