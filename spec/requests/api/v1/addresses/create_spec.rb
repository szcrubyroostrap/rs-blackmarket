describe 'POST /api/v1/user/addresses', type: :request do
  subject { post api_v1_user_addresses_path, headers: headers, params: params, as: :json }

  let(:headers) { auth_headers }
  let(:user) { create(:user) }
  let(:city) { create(:city) }
  let(:home_address) { Faker::Address.street_address }
  let(:zip_code) { Faker::Address.zip_code }
  let(:params) do
    {
      address: {
        home_address: home_address,
        zip_code: zip_code,
        city_id: city.id
      }
    }
  end

  before { subject }

  context 'when response is successful' do
    it_behaves_like 'a successful request'

    it 'returns address info' do
      expect(json).to include_json(
        home_address: home_address,
        zip_code: zip_code,
        city: {
          id: city.id,
          name: city.name,
          country: {
            id: city.country.id,
            name: city.country.name
          }
        },
        user: {
          id: user.id,
          email: user.email
        }
      )
    end
  end

  context 'when response is an error' do
    context 'when request format is not valid' do
      let(:params) { { home_addresses: home_address, zip_code: zip_code } }

      it_behaves_like 'a bad request'
    end

    context 'when user not logged in' do
      let(:headers) { nil }

      it_behaves_like 'an unauthorised request'
    end
  end
end
