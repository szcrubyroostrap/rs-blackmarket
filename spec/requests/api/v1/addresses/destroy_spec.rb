describe 'DELETE /api/v1/user/addresses/:id', type: :request do
  subject do
    delete api_v1_user_address_path(address.id), headers: headers, as: :json
  end

  let(:headers) { auth_headers }
  let(:user) { create(:user) }
  let(:city) { create(:city) }

  before { subject }

  context 'when response is successful' do
    let(:address) { create(:address, user: user, city: city) }

    it 'returns no content status code' do
      expect(response).to be_no_content
    end
  end

  context 'when response is an error' do
    context 'when user not logged in' do
      let(:headers) { nil }
      let(:address) { create(:address, user: user, city: city) }

      it_behaves_like 'an unauthorised request'
    end

    context 'when address does not exist' do
      let(:address) { build(:address, id: 1, user: user, city: city) }

      it_behaves_like 'a not found request'
    end
  end
end
