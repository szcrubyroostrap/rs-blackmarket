describe Api::V1::CartsController, type: :routing do
  describe 'routing' do
    it 'routes to #add_product' do
      expect(put: '/api/v1/carts/add_product').to route_to('api/v1/carts#add_product',
                                                           format: :json)
    end

    it 'routes to #remove_product' do
      expect(put: '/api/v1/carts/remove_product').to route_to('api/v1/carts#remove_product',
                                                              format: :json)
    end

    it 'routes to #collection' do
      expect(get: '/api/v1/carts/collection').to route_to('api/v1/carts#collection',
                                                          format: :json)
    end
  end
end
