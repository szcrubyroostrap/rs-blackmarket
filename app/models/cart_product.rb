class CartProduct < ApplicationRecord
  include Validators::CartProductValidator

  belongs_to :cart
  belongs_to :product

  validates :quantity, :total_amount, numericality: { greater_than_or_equal_to: 0 }, presence: true
end
