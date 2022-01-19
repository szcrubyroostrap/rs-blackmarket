module Services
  class RemoveMoreProductsThanWereAddedError < StandardError
    def initialize(msg = 'the product units to be removed exceed those added to the cart')
      super(msg)
    end
  end
end
