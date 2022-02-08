describe 'GET /api/v1/countries/:country_id/cities', type: :request do
  subject { get api_v1_country_cities_path(country_id: country.id), headers: headers, as: :json }

  let(:headers) { auth_headers }
  let(:user) { create(:user) }
  let!(:country) { create(:country) }

  context 'when there are cities created' do
    let!(:cities) { create_list(:city, 2, country: country) }

    before { subject }

    it_behaves_like 'a successful request'

    it 'returns cities info' do
      expect(json).to include_json(
        cities: cities.map do |city|
          {
            id: city.id,
            name: city.name
          }
        end
      )
    end
  end

  context 'when there is not a city created' do
    before { subject }

    it_behaves_like 'a successful request'

    it 'returns city info' do
      expect(json).to include_json(cities: [])
    end
  end

  context 'when user not logged in' do
    let(:headers) { nil }

    before { subject }

    it_behaves_like 'an unauthorised request'
  end
end
