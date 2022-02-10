describe 'DELETE api/v1/countries/:country_id/cities/:id', type: :request do
  subject do
    delete api_v1_country_city_path(country_id: city.country.id, id: city.id), headers: headers,
                                                                               as: :json
  end

  let(:headers) { auth_headers }
  let(:user) { create(:user) }

  before { subject }

  context 'when response is successful' do
    let(:city) { create(:city) }

    it 'returns no content status code' do
      expect(response).to be_no_content
    end
  end

  context 'when response is an error' do
    context 'when user not logged in' do
      let(:headers) { nil }
      let(:city) { create(:city) }

      it_behaves_like 'an unauthorised request'
    end

    context 'when city does not exist' do
      let(:city) { build(:city, id: 1) }

      it_behaves_like 'a not found request'
    end
  end
end
