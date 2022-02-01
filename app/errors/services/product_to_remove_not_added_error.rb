module Services
  class ProductToRemoveNotAddedError < StandardError
    def initialize(product_id:)
      msg = I18n.t('errors.product_to_remove_not_added', product_id: product_id)

      super(msg)
    end
  end
end
