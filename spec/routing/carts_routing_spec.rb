describe Api::V1::CartsController, type: :routing do
  describe 'routing' do
    it 'routes to #show' do
      expect(get: '/api/v1/cart').to route_to('api/v1/carts#show', format: :json)
    end
  end
end
