class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_products, dependent: :destroy
  has_many :products, through: :cart_products

  enum status: {
    in_process: 0,
    completed: 1
  }

  def calculate_total_items
    cart_products.sum(&:quantity)
  end

  def calculate_total_price
    cart_products.sum(&:total_amount)
  end
end