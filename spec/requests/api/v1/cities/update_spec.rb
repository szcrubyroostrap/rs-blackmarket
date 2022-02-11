describe 'PUT /api/v1/countries/:country_id/cities/:id', type: :request do
  subject do
    put api_v1_country_city_path(country_id: city.country.id, id: city_id), headers: headers,
                                                                            params: params,
                                                                            as: :json
  end

  let(:headers) { auth_headers }
  let(:user) { create(:user) }
  let!(:city) { create(:city) }
  let(:city_id) { city.id }
  let(:params) do
    {
      city: {
        name: city_name
      }
    }
  end

  context 'when response is successful' do
    let(:city_name) { 'foo' }

    it_behaves_like 'a successful request'

    it 'returns city info' do
      subject

      expect(json).to include_json(
        id: city.id,
        name: city_name,
        country: {
          id: city.country.id,
          name: city.country.name
        }
      )
    end

    it 'does not modify country table size' do
      expect { subject }.not_to change { City.count }
    end

    it 'uploads name attribute' do
      old_city_name = city.name

      expect { subject }.to change { city.reload.name }.to(city_name).from(old_city_name)
    end
  end

  context 'when response is an error' do
    let(:city_name) { city.name }

    context 'when city does not exist' do
      let(:city_id) { 0 }

      it_behaves_like 'a not found request'
    end

    context 'when request format is not valid' do
      let(:params) { { names: city.name } }

      it_behaves_like 'a bad request'
    end

    context 'when user not logged in' do
      let(:headers) { nil }

      it_behaves_like 'an unauthorised request'
    end

    context 'when city name is already taken' do
      let(:first_city) { create(:city) }
      let(:city_name) { first_city.name }

      it_behaves_like 'a bad request'
    end
  end
end
