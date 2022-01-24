module Validators
  module CartProductValidator
    extend ActiveSupport::Concern

    included do
      validate :active_product
      validate :product_quantity
    end

    private

    def active_product
      return if product&.active?

      errors.add(:base, 'Product is not available')
    end

    def product_quantity
      return if product && product.stock >= quantity

      errors.add(:base, 'Product quantity cannot be added')
    end
  end
end
