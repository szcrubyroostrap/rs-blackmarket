describe Api::V1::CartsController, type: :routing do
  describe 'routing' do
    it 'routes to #add_product' do
      expect(post: '/api/v1/carts/add_product').to route_to('api/v1/carts#add_product',
                                                            format: :json)
    end

    it 'routes to #remove_product' do
      expect(post: '/api/v1/carts/remove_product').to route_to('api/v1/carts#remove_product',
                                                               format: :json)
    end
  end
end
