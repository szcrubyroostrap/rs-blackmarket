describe Api::V1::CitiesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/api/v1/countries/1/cities').to route_to(
        controller: 'api/v1/cities',
        action: 'index', country_id: '1',
        format: :json
      )
    end

    it 'routes to #create' do
      expect(post: '/api/v1/countries/1/cities').to route_to(
        controller: 'api/v1/cities',
        action: 'create', country_id: '1',
        format: :json
      )
    end

    it 'routes to #show' do
      expect(get: '/api/v1/countries/1/cities/2').to route_to(
        controller: 'api/v1/cities',
        action: 'show', id: '2',
        country_id: '1', format: :json
      )
    end

    it 'routes to #update' do
      expect(put: '/api/v1/countries/1/cities/2').to route_to(
        controller: 'api/v1/cities',
        action: 'update', id: '2',
        country_id: '1', format: :json
      )
    end

    it 'routes to #delete' do
      expect(delete: '/api/v1/countries/1/cities/2').to route_to(
        controller: 'api/v1/cities',
        action: 'destroy', id: '2',
        country_id: '1', format: :json
      )
    end
  end
end
