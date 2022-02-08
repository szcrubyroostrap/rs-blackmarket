describe 'POST /api/v1/countries', type: :request do
  subject { post api_v1_countries_path, headers: headers, params: params, as: :json }

  let(:headers) { auth_headers }
  let(:user) { create(:user) }
  let(:params) do
    {
      country: {
        name: country.name
      }
    }
  end

  before { subject }

  context 'when response is successful' do
    let(:country) { build(:country) }

    it_behaves_like 'a successful request'

    it 'returns country info' do
      expect(json).to include_json(
        name: country.name
      )
    end
  end

  context 'when response is an error' do
    context 'when request format is not valid' do
      let(:country) { build(:country) }
      let(:params) { { names: country.name } }

      it_behaves_like 'a bad request'
    end

    context 'when country name is already taken' do
      let(:country) { create(:country) }

      it_behaves_like 'a bad request'
    end

    context 'when user not logged in' do
      let(:country) { build(:country) }
      let(:headers) { nil }

      it_behaves_like 'an unauthorised request'
    end
  end
end
