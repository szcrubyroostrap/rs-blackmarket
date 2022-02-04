describe Api::V1::AddressesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/users/1/addresses').to route_to(controller: 'api/v1/addresses',
                                                           action: 'index', user_id: '1',
                                                           format: :json)
    end

    it 'routes to #create' do
      expect(post: '/api/v1/users/1/addresses').to route_to(controller: 'api/v1/addresses',
                                                            action: 'create', user_id: '1',
                                                            format: :json)
    end

    it 'routes to #show' do
      expect(get: '/api/v1/users/1/addresses/2').to route_to(controller: 'api/v1/addresses',
                                                             action: 'show', id: '2',
                                                             user_id: '1', format: :json)
    end

    it 'routes to #update' do
      expect(put: '/api/v1/users/1/addresses/2').to route_to(controller: 'api/v1/addresses',
                                                             action: 'update', id: '2',
                                                             user_id: '1', format: :json)
    end

    it 'routes to #delete' do
      expect(delete: '/api/v1/users/1/addresses/2').to route_to(controller: 'api/v1/addresses',
                                                                action: 'destroy', id: '2',
                                                                user_id: '1', format: :json)
    end
  end
end
