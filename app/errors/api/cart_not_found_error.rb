module Api
  class CartNotFoundError < StandardError
    def initialize(user_id:)
      msg = I18n.t('errors.cart_not_found', user_id: user_id)

      super(msg)
    end
  end
end
