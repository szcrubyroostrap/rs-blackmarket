class CartItemsManagementService
  attr_reader :cart, :product, :quantity, :cart_product

  def initialize(cart, product, quantity = 0)
    @cart = cart
    @product = product
    @quantity = quantity
    @cart_product = CartProduct.find_by(cart: cart, product: product)
  end

  def create_product_in_cart
    raise Services::CreatingProductInCartError, product_id_data if cart_product

    @quantity = 1
    @cart_product = CartProduct.create!(cart: cart, product: product, quantity: quantity,
                                        total_amount: product.price)

    update_cart!
  end

  def remove_product_from_cart
    raise Services::ProductToRemoveNotAddedError, product_id_data unless cart_product

    cart_product.destroy!

    update_cart!
  end

  def update_product_units_in_cart(units)
    @quantity = units
    validate_quantity!

    raise Services::MissingProductUpdateError, product_id_data unless cart_product

    cart_product.quantity += quantity
    product_operation

    update_cart!
  end

  private

  def update_cart!
    @cart.update!(total_items: cart.calculate_total_items,
                  total_price: cart.calculate_total_price)
  end

  def product_operation
    remaining_quantity = cart_product.quantity
    validate_products_quantity_to_remove!(remaining_quantity)

    if remaining_quantity.zero?
      cart_product.destroy!
    else
      cart_product.total_amount = product.price * remaining_quantity
      cart_product.save!
    end
  end

  def validate_quantity!
    raise Services::UnitsToOperateError if !quantity.is_a?(Integer) || quantity.zero?
  end

  def validate_products_quantity_to_remove!(quantity_available)
    error_data = product_id_data.merge(quantity: quantity)

    raise Services::RemoveMoreProductsThanWereAddedError, error_data if quantity_available.negative?
  end

  def product_id_data
    { product_id: product.id }
  end
end
