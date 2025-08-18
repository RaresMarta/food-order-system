class FoodItem < ApplicationRecord
  has_many :order_items
  has_many :cart_items, dependent: :destroy
  has_many :users, through: :cart_items

  has_one_attached :image

  validates :name, presence: true, length: { maximum: 100 }
  validates :category, presence: true, length: { maximum: 50 }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :vegetarian, inclusion: { in: [ true, false ] }

  scope :filter_by_category, ->(cat) {
    cat.present? && cat != "default" ? active.where(category: cat) : active
  }

  scope :vegetarian_only, ->(veg) {
    veg.present? ? active.where(vegetarian: ActiveModel::Type::Boolean.new.cast(veg)) : active
  }

  scope :price_between, ->(min, max) {
    min_val = min.present? ? min.to_f : 0
    max_val = max.present? ? max.to_f : 100
    min_val <= max_val ? active.where(price: min_val..max_val) : active
  }

  scope :sorted_by_price, ->(order) {
    %w[asc desc].include?(order) ? active.order(price: order.to_sym) : active
  }

  scope :active, -> { where(deleted_at: nil) }

  def soft_delete!
    update(deleted_at: Time.current)
  end

  def deleted?
    deleted_at.present?
  end
end
