module Services
  class UnitsToOperateError < StandardError
    def initialize(msg = I18n.t('errors.units_to_operate'))
      super(msg)
    end
  end
end
