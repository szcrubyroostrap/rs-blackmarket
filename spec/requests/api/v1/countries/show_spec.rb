describe 'GET /api/v1/contries/:id', type: :request do
  subject { get api_v1_country_path(country_id), headers: headers, as: :json }

  let(:headers) { auth_headers }
  let(:user) { create(:user) }
  let!(:country) { create(:country) }
  let(:country_id) { country.id }

  context 'when response is an error' do
    context 'when country does not exist' do
      let(:country_id) { 0 }

      it_behaves_like 'a not found request'
    end

    context 'when user not logged in' do
      let(:headers) { nil }

      it_behaves_like 'an unauthorised request'
    end
  end

  context 'when response is successful' do
    it_behaves_like 'a successful request'

    it 'returns country info' do
      subject

      expect(json).to include_json(
        id: country.id,
        name: country.name
      )
    end
  end
end
