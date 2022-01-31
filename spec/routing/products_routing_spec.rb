describe Api::V1::ProductsController, type: :routing do
  describe 'routing' do
    it 'routes to #create' do
      expect(post: '/api/v1/cart/products').to route_to(controller: 'api/v1/products',
                                                        action: 'create', format: :json)
    end

    it 'routes to #delete' do
      expect(delete: '/api/v1/cart/products/1').to route_to(controller: 'api/v1/products',
                                                            action: 'destroy', id: '1',
                                                            format: :json)
    end

    it 'routes to #update' do
      expect(put: '/api/v1/cart/products/1').to route_to(controller: 'api/v1/products',
                                                         action: 'update', id: '1', format: :json)
    end
  end
end
