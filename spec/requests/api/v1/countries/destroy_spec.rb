describe 'DELETE /api/v1/countries/:id', type: :request do
  subject { delete api_v1_country_path(country_id), headers: headers, as: :json }

  let(:headers) { auth_headers }
  let(:user) { create(:user) }
  let!(:country) { create(:country) }
  let(:country_id) { country.id }

  context 'when response is successful' do
    it 'returns no content status code' do
      subject

      expect(response).to be_no_content
    end

    it 'deletes the country' do
      expect { subject }.to change { Country.count }.by(-1)
    end
  end

  context 'when response is an error' do
    context 'when user not logged in' do
      let(:headers) { nil }

      it_behaves_like 'an unauthorised request'
    end

    context 'when country does not exist' do
      let(:country_id) { '0' }

      it_behaves_like 'a not found request'
    end
  end
end
