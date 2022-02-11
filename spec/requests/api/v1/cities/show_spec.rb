describe 'GET /api/v1/countries/:country_id/cities/:id', type: :request do
  subject do
    get api_v1_country_city_path(country_id: city.country.id, id: city_id), headers: headers,
                                                                            as: :json
  end

  let(:headers) { auth_headers }
  let(:user) { create(:user) }
  let!(:city) { create(:city) }
  let(:city_id) { city.id }

  context 'when response is an error' do
    let(:city_id) { 0 }

    context 'when city does not exist' do
      it_behaves_like 'a not found request'
    end

    context 'when user not logged in' do
      let(:headers) { nil }

      it_behaves_like 'an unauthorised request'
    end
  end

  context 'when response is successful' do
    it_behaves_like 'a successful request'

    it 'returns city info' do
      subject

      expect(json).to include_json(
        id: city.id,
        name: city.name,
        country: {
          id: city.country.id,
          name: city.country.name
        }
      )
    end
  end
end
