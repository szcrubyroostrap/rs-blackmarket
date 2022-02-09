describe 'POST /api/v1/countries/:country_id/cities', type: :request do
  subject do
    post api_v1_country_cities_path(country_id: country.id), headers: headers, params: params,
                                                             as: :json
  end

  let(:headers) { auth_headers }
  let(:user) { create(:user) }
  let(:country) { create(:country) }
  let(:city_name) { Faker::Address.city }
  let(:params) do
    {
      city: {
        name: city_name
      }
    }
  end

  before { subject }

  context 'when response is successful' do
    it_behaves_like 'a successful request'

    it 'returns city info' do
      expect(json).to include_json(
        country: {
          id: country.id,
          name: country.name
        },
        name: city_name
      )
    end
  end

  context 'when response is an error' do
    context 'when request format is not valid' do
      let(:params) { { names: city_name } }

      it_behaves_like 'a bad request'
    end

    context 'when city name is already taken' do
      let(:city) { create(:city, country: country) }
      let(:city_name) { city.name }

      it_behaves_like 'a bad request'
    end

    context 'when user not logged in' do
      let(:headers) { nil }

      it_behaves_like 'an unauthorised request'
    end
  end
end
