describe 'POST /api/v1/countries', type: :request do
  subject { post api_v1_countries_path, headers: headers, params: params, as: :json }

  let(:headers) { auth_headers }
  let(:user) { create(:user) }
  let(:country_name) { Faker::Address.country }
  let(:params) do
    {
      country: {
        name: country_name
      }
    }
  end

  context 'when response is successful' do
    it_behaves_like 'a successful request'

    it 'returns country info' do
      subject

      expect(json).to include_json(
        name: country_name
      )
    end

    it 'creates the country' do
      expect { subject }.to change { Country.count }.by(1)
    end
  end

  context 'when response is an error' do
    context 'when request format is not valid' do
      let(:params) { { names: country_name } }

      it_behaves_like 'a bad request'
    end

    context 'when country name is already taken' do
      let(:country) { create(:country) }
      let(:country_name) { country.name }

      it_behaves_like 'a bad request'
    end

    context 'when user not logged in' do
      let(:headers) { nil }

      it_behaves_like 'an unauthorised request'
    end
  end
end
