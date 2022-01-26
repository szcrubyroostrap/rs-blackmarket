module Services
  class RemoveMoreProductsThanWereAddedError < StandardError
    def initialize(quantity:, product_id:)
      error_key = 'errors.remove_more_products_than_were_added'
      msg = I18n.t(error_key, quantity: quantity, product_id: product_id)

      super(msg)
    end
  end
end
