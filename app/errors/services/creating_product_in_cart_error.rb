module Services
  class CreatingProductInCartError < StandardError
    def initialize(product_id:)
      msg = I18n.t('errors.creating_product_in_cart', product_id: product_id)

      super(msg)
    end
  end
end
