class Cart < ApplicationRecord
  belongs_to :user
  has_many :cart_products, dependent: :destroy
  has_many :products, through: :cart_products

  enum status: {
    in_process: 0,
    completed: 1
  }

  validates :total_items, :total_price, numericality: { greater_than_or_equal_to: 0 },
                                        presence: true

  def calculate_total_items
    cart_products.sum(&:quantity)
  end

  def calculate_total_price
    cart_products.sum(&:total_amount)
  end
end
