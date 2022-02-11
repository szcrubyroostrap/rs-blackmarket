describe Api::V1::AddressesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/user/addresses').to route_to(controller: 'api/v1/addresses',
                                                        action: 'index', format: :json)
    end

    it 'routes to #create' do
      expect(post: '/api/v1/user/addresses').to route_to(controller: 'api/v1/addresses',
                                                         action: 'create', format: :json)
    end

    it 'routes to #show' do
      expect(get: '/api/v1/user/addresses/1').to route_to(controller: 'api/v1/addresses',
                                                          action: 'show', id: '1', format: :json)
    end

    it 'routes to #update' do
      expect(put: '/api/v1/user/addresses/1').to route_to(controller: 'api/v1/addresses',
                                                          action: 'update', id: '1', format: :json)
    end

    it 'routes to #delete' do
      expect(delete: '/api/v1/user/addresses/1').to route_to(controller: 'api/v1/addresses',
                                                             action: 'destroy', id: '1',
                                                             format: :json)
    end
  end
end
