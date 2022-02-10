describe 'GET /api/v1/contries/:id', type: :request do
  subject { get api_v1_country_path(country.id), headers: headers, as: :json }

  let(:headers) { auth_headers }
  let(:user) { create(:user) }

  before { subject }

  context 'when response is an error' do
    let(:country) { build(:country, id: 0) }

    context 'when country does not exist' do
      it_behaves_like 'a not found request'
    end

    context 'when user not logged in' do
      let(:headers) { nil }

      it_behaves_like 'an unauthorised request'
    end
  end

  context 'when response is successful' do
    let(:country) { create(:country) }

    it_behaves_like 'a successful request'

    it 'returns country info' do
      expect(json).to include_json(
        id: country.id,
        name: country.name
      )
    end
  end
end
