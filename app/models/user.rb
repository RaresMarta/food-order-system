class User < ApplicationRecord
  has_many :cart_items, dependent: :destroy
  has_many :food_items, through: :cart_items

  has_secure_password

  validates :email, presence: true, uniqueness: true,
    format: { with: /\A[^@\s]+@[^@\s]+\.[^@\s]+\z/, message: "is invalid" }
  validates :name, presence: true
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }

  before_save :downcase_email

  private

  def downcase_email
    self.email = email.downcase
  end
end
