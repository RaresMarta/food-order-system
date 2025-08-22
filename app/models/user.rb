class User < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :food_items, through: :cart_items
  has_many :orders

  devise :database_authenticatable, :registerable, :recoverable, :rememberable, :validatable

  enum :role, { customer: 0, admin: 1 }

  validates :name, presence: true
  validates :email, presence: true
  validates :role, presence: true

  before_save :downcase_email

  private

  def downcase_email
    self.email = email.downcase
  end
end
