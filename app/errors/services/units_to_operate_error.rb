module Services
  class UnitsToOperateError < StandardError
    def initialize(msg = 'it is not possible to operate with the quantity supplied')
      super(msg)
    end
  end
end
