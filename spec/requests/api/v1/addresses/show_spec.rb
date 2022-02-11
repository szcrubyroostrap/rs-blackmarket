describe 'GET /api/v1/user/addresses/:id', type: :request do
  subject do
    get api_v1_user_address_path(address.id), headers: headers, as: :json
  end

  let(:headers) { auth_headers }
  let(:user) { create(:user) }
  let(:city) { create(:city) }

  before { subject }

  context 'when response is an error' do
    let(:address) { build(:address, id: 0, user: user, city: city) }

    context 'when address does not exist' do
      it_behaves_like 'a not found request'
    end

    context 'when user not logged in' do
      let(:headers) { nil }

      it_behaves_like 'an unauthorised request'
    end
  end

  context 'when response is successful' do
    let(:address) { create(:address, user: user, city: city) }

    it_behaves_like 'a successful request'

    it 'returns address info' do
      expect(json).to include_json(
        id: address.id,
        home_address: address.home_address,
        zip_code: address.zip_code,
        user: {
          id: user.id,
          email: user.email
        },
        city: {
          id: city.id,
          name: city.name,
          country: {
            id: city.country.id,
            name: city.country.name
          }
        }
      )
    end
  end
end
