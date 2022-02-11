describe 'GET /api/v1/countries', type: :request do
  subject { get api_v1_countries_path, headers: headers, as: :json }

  let(:headers) { auth_headers }
  let(:user) { create(:user) }

  context 'when there are countries created' do
    let!(:countries) { create_list(:country, 2) }

    it_behaves_like 'a successful request'

    it 'returns country info' do
      subject

      expect(response.body).to include_json(
        countries.map do |country|
          {
            id: country.id,
            name: country.name
          }
        end
      )
    end
  end

  context 'when there is not a country created' do
    it_behaves_like 'a successful request'

    it 'returns empty country info' do
      subject

      expect(response.body).to include_json([])
    end
  end

  context 'when user not logged in' do
    let(:country) { create(:country) }
    let(:headers) { nil }

    it_behaves_like 'an unauthorised request'
  end
end
