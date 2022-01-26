class CartItemsManagementService
  attr_reader :cart, :product, :quantity

  def initialize(cart, product, quantity)
    @cart = cart
    @product = product
    @quantity = quantity
  end

  def add_to_cart
    validate_quantity!

    cart_product = CartProduct.find_or_initialize_by(cart: cart, product: product)
    cart_product.quantity += quantity
    cart_product.total_amount = product.price * cart_product.quantity
    cart_product.save!

    update_cart!
  end

  def remove_from_cart
    validate_quantity!

    cart_product = CartProduct.find_by(cart: cart, product: product)
    raise Services::ProductToRemoveNotAddedError unless cart_product

    cart_product.quantity -= quantity

    validate_products_quantity_to_remove!(cart_product.quantity)
    product_extraction(cart_product)

    update_cart!
  end

  private

  def update_cart!
    @cart.update!(total_items: cart.calculate_total_items,
                  total_price: cart.calculate_total_price)
  end

  def product_extraction(cart_product)
    if cart_product.quantity.zero?
      cart_product.destroy!
    else
      cart_product.total_amount = product.price * cart_product.quantity
      cart_product.save!
    end
  end

  def validate_quantity!
    raise Services::UnitsToOperateError if !@quantity.is_a?(Integer) || @quantity <= 0
  end

  def validate_products_quantity_to_remove!(quantity_available)
    error_data = { product_id: product.id, quantity: quantity } if quantity_available.negative?

    raise Services::RemoveMoreProductsThanWereAddedError, error_data if quantity_available.negative?
  end
end
