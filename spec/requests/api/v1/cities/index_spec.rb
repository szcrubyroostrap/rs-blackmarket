describe 'GET /api/v1/countries/:country_id/cities', type: :request do
  subject { get api_v1_country_cities_path(country_id: country.id), headers: headers, as: :json }

  let(:headers) { auth_headers }
  let(:user) { create(:user) }
  let(:country) { create(:country) }

  context 'when there are cities created' do
    let!(:cities) { create_list(:city, 2, country: country) }

    it_behaves_like 'a successful request'

    it 'returns cities info' do
      subject

      expect(response.body).to include_json(
        cities.map do |city|
          {
            id: city.id,
            name: city.name,
            country: {
              id: city.country.id,
              name: city.country.name
            }
          }
        end
      )
    end
  end

  context 'when there is not a city created' do
    it_behaves_like 'a successful request'

    it 'returns empty city info' do
      subject

      expect(response.body).to include_json([])
    end
  end

  context 'when user not logged in' do
    let(:headers) { nil }

    it_behaves_like 'an unauthorised request'
  end
end
