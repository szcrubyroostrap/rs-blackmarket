describe 'PUT /api/v1/countries/:id', type: :request do
  subject { put api_v1_country_path(country_id), headers: headers, params: params, as: :json }

  let(:headers) { auth_headers }
  let(:user) { create(:user) }
  let!(:country) { create(:country) }
  let(:country_id) { country.id }
  let(:params) do
    {
      country: {
        name: name
      }
    }
  end

  context 'when response is successful' do
    let(:name) { 'foo' }

    it_behaves_like 'a successful request'

    it 'returns country info' do
      subject

      expect(json).to include_json(
        id: country.id,
        name: name
      )
    end

    it 'does not modify country table size' do
      expect { subject }.not_to change { Country.count }
    end

    it 'uploads name attribute' do
      country_name = country.name

      expect { subject }.to change { country.reload.name }.to(name).from(country_name)
    end
  end

  context 'when response is an error' do
    let(:name) { country.name }

    context 'when country does not exist' do
      let(:country_id) { 0 }

      it_behaves_like 'a not found request'
    end

    context 'when request format is not valid' do
      let(:params) { { names: country.name } }

      it_behaves_like 'a bad request'
    end

    context 'when user not logged in' do
      let(:headers) { nil }

      it_behaves_like 'an unauthorised request'
    end

    context 'when country name is already taken' do
      let(:first_country) { create(:country) }
      let(:name) { first_country.name }

      it_behaves_like 'a bad request'
    end
  end
end
