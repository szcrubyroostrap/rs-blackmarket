describe 'PUT /api/v1/user/addresses/:id', type: :request do
  subject do
    put api_v1_user_address_path(address.id), headers: headers, params: params, as: :json
  end

  let(:headers) { auth_headers }
  let(:user) { create(:user) }
  let(:city) { create(:city) }
  let(:home_address) { 'street 1234' }
  let(:zip_code) { '4321' }
  let(:params) do
    {
      address: {
        home_address: home_address,
        zip_code: zip_code
      }
    }
  end

  before { subject }

  context 'when response is successful' do
    let(:address) { create(:address, user: user, city: city) }

    it_behaves_like 'a successful request'

    it 'returns city info' do
      expect(json).to include_json(
        id: address.id,
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
    context 'when city does not exist' do
      let(:address) { build(:address, id: 1, user: user, city: city) }

      it_behaves_like 'a not found request'
    end

    context 'when request format is not valid' do
      let(:address) { create(:address, user: user, city: city) }
      let(:params) { { home: home_address, zip_codee: zip_code } }

      it_behaves_like 'a bad request'
    end

    context 'when user not logged in' do
      let(:headers) { nil }
      let(:address) { create(:address, user: user, city: city) }

      it_behaves_like 'an unauthorised request'
    end
  end
end
