module Services
  class ProductToRemoveNotAddedError < StandardError
    def initialize(msg = 'there are no units of this product in the cart to remove')
      super(msg)
    end
  end
end
