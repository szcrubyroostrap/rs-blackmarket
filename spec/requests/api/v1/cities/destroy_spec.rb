describe 'DELETE api/v1/countries/:country_id/cities/:id', type: :request do
  subject do
    delete api_v1_country_city_path(country_id: city.country.id, id: city_id), headers: headers,
                                                                               as: :json
  end

  let(:headers) { auth_headers }
  let(:user) { create(:user) }
  let!(:city) { create(:city) }
  let(:city_id) { city.id }

  context 'when response is successful' do
    it 'returns no content status code' do
      subject

      expect(response).to be_no_content
    end

    it 'deletes the city' do
      expect { subject }.to change { City.count }.by(-1)
    end
  end

  context 'when response is an error' do
    context 'when user not logged in' do
      let(:headers) { nil }

      it_behaves_like 'an unauthorised request'
    end

    context 'when city does not exist' do
      let(:city_id) { 0 }

      it_behaves_like 'a not found request'
    end
  end
end
