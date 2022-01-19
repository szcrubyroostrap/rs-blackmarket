class CartProduct < ApplicationRecord
  belongs_to :cart
  belongs_to :product

  validates :quantity, :total_amount, numericality: { greater_than: 0 }, presence: true

  validate :active_product, :product_quantity

  private

  def active_product
    return if product.active?

    errors.add(:base, 'Product is not available')
  end

  def product_quantity
    return if product.stock > quantity

    errors.add(:base, 'Product quantity cannot be added')
  end
end
