module Services
  class ProductToRemoveNotAddedError < StandardError
    def initialize(msg = I18n.t('errors.product_to_remove_not_added'))
      super(msg)
    end
  end
end
