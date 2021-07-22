describe 'POST api/v1/users/', type: :request do
  let(:user)            { User.last }
  let(:failed_response) { 422 }

  describe 'POST create' do
    let(:email)                 { 'test@test.com' }
    let(:password)              { '12345678' }
    let(:password_confirmation) { '12345678' }

    let(:params) do
      {
        user: {
          email: email,
          password: password,
          password_confirmation: password_confirmation
        }
      }
    end

    let(:http_request) { post '/api/v1/users', params: params, as: :json }

    it 'returns a successful response' do
      http_request
      expect(response).to have_http_status(:success)
    end

    it 'creates the user' do
      expect { http_request }.to change(User, :count).by(1)
    end

    it 'returns the user' do
      http_request
      expect(json[:data][:id]).to eq(user.id)
      expect(json[:data][:email]).to eq(user.email)
    end

    context 'when the email is not correct' do
      let(:email) { 'invalid_email' }

      it 'does not create a user' do
        expect { http_request }.not_to change { User.count }
      end

      it 'does not return a successful response' do
        http_request
        expect(response.status).to eq(failed_response)
      end
    end

    context 'when the password is incorrect' do
      let(:password)              { 'short' }
      let(:password_confirmation) { 'short' }
      let(:new_user)              { User.find_by(email: email) }

      it 'does not create a user' do
        http_request
        expect(new_user).to be_nil
      end

      it 'does not return a successful response' do
        http_request
        expect(response.status).to eq(failed_response)
      end
    end

    context 'when passwords don\'t match' do
      let(:password)              { 'shouldmatch' }
      let(:password_confirmation) { 'dontmatch' }
      let(:new_user)              { User.find_by(email: email) }

      it 'does not create a user' do
        http_request
        expect(new_user).to be_nil
      end

      it 'does not return a successful response' do
        http_request
        expect(response.status).to eq(failed_response)
      end
    end
  end
end
