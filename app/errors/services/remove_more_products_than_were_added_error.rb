module Services
  class RemoveMoreProductsThanWereAddedError < StandardError
    def initialize(data)
      error_key = 'errors.remove_more_products_than_were_added'
      msg = I18n.t(error_key, quantity: data[:quantity], product_id: data[:product_id])

      super(msg)
    end
  end
end
