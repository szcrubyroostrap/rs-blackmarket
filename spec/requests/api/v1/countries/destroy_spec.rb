describe 'DELETE /api/v1/countries/:id', type: :request do
  subject { delete api_v1_country_path(country.id), headers: headers, as: :json }

  let(:headers) { auth_headers }
  let(:user) { create(:user) }

  before { subject }

  context 'when response is successful' do
    let(:country) { create(:country) }

    it 'returns no content status code' do
      expect(response).to be_no_content
    end
  end

  context 'when response is an error' do
    context 'when user not logged in' do
      let(:headers) { nil }
      let(:country) { create(:country) }

      it_behaves_like 'an unauthorised request'
    end

    context 'when country does not exist' do
      let(:country) { build(:country, id: 1) }

      it_behaves_like 'a not found request'
    end
  end
end
