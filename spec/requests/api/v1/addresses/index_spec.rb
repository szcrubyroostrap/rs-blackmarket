describe 'GET /api/v1/user/addresses', type: :request do
  subject { get api_v1_user_addresses_path, headers: headers, as: :json }

  let(:headers) { auth_headers }
  let(:user) { create(:user) }
  let(:city) { create(:city) }

  context 'when there are addresses created' do
    let(:addresses) { create_list(:address, 2, user: user, city: city) }

    before do
      addresses
      subject
    end

    it_behaves_like 'a successful request'

    it 'returns addresses info' do
      expect(response.body).to include_json(
        addresses.map do |address|
          {
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
          }
        end
      )
    end
  end

  context 'when there is not a city created' do
    before { subject }

    it_behaves_like 'a successful request'

    it 'returns empty address info' do
      expect(response.body).to include_json([])
    end
  end

  context 'when user not logged in' do
    let(:headers) { nil }

    before { subject }

    it_behaves_like 'an unauthorised request'
  end
end
