describe 'PUT /api/v1/countries/:id', type: :request do
  subject { put api_v1_country_path(country.id), headers: headers, params: params, as: :json }

  let(:headers) { auth_headers }
  let(:user) { create(:user) }
  let(:params) do
    {
      country: {
        name: name
      }
    }
  end

  before { subject }

  context 'when response is successful' do
    let(:country) { create(:country) }
    let(:name) { 'foo' }

    it_behaves_like 'a successful request'

    it 'returns country info' do
      expect(json).to include_json(
        id: country.id,
        name: name
      )
    end
  end

  context 'when response is an error' do
    let(:name) { country.name }

    context 'when country does not exist' do
      let(:country) { build(:country, id: 1) }

      it_behaves_like 'a not found request'
    end

    context 'when request format is not valid' do
      let(:country) { create(:country) }
      let(:params) { { names: country.name } }

      it_behaves_like 'a bad request'
    end

    context 'when user not logged in' do
      let(:headers) { nil }
      let(:country) { create(:country) }

      it_behaves_like 'an unauthorised request'
    end

    context 'when country name is already taken' do
      let(:country) { create(:country) }
      let(:first_country) { create(:country) }
      let(:name) { first_country.name }

      it_behaves_like 'a bad request'
    end
  end
end
