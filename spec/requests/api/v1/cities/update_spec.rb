describe 'PUT /api/v1/countries/:country_id/cities/:id', type: :request do
  subject do
    put api_v1_country_city_path(country_id: city.country.id, id: city.id), headers: headers,
                                                                            params: params,
                                                                            as: :json
  end

  let(:headers) { auth_headers }
  let(:user) { create(:user) }
  let(:params) do
    {
      city: {
        name: city_name
      }
    }
  end

  context 'when response is successful' do
    let(:city) { create(:city) }
    let(:city_name) { 'foo' }

    before { subject }

    it_behaves_like 'a successful request'

    it 'returns city info' do
      expect(json).to include_json(
        id: city.id,
        name: city_name
      )
    end
  end

  context 'when response is an error' do
    let(:city_name) { city.name }

    before { subject }

    context 'when city does not exist' do
      let(:city) { build(:city, id: 1) }

      it_behaves_like 'a not found request'
    end

    context 'when request format is not valid' do
      let(:city) { create(:city) }
      let(:params) { { names: city.name } }

      it_behaves_like 'a bad request'
    end

    context 'when user not logged in' do
      let(:headers) { nil }
      let(:city) { create(:city) }

      it_behaves_like 'an unauthorised request'
    end

    context 'when city name is already taken' do
      let(:city) { create(:city) }
      let(:first_city) { create(:city) }
      let(:city_name) { first_city.name }

      it_behaves_like 'a bad request'
    end
  end
end
