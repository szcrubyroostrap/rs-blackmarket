module Services
  class MissingProductUpdateError < StandardError
    def initialize(product_id:)
      msg = I18n.t('errors.missing_product_update', product_id: product_id)

      super(msg)
    end
  end
end
