require 'rails_helper'

describe 'POST api/v1/users/sign_in', type: :request do
  let(:password) { 'password' }
  let(:user) { create(:user, password: password) }
  let(:params) do
    {
      user:
        {
          email: user.email,
          password: password
        }
    }
  end

  context 'with correct params' do
    before do
      post '/api/v1/users/sign_in/', params: params, as: :json
    end

    it 'returns success' do
      expect(response).to be_successful
    end

    it 'returns the user' do
      expect(json[:data][:id]).to eq(user.id)
      expect(json[:data][:email]).to eq(user.email)
      expect(json[:data][:uid]).to eq(user.uid)
    end

    it 'returns a valid client and access token' do
      token = response.header['access-token']
      client = response.header['client']
      expect(user.reload.valid_token?(token, client)).to be_truthy
    end
  end

  context 'with incorrect params' do
    let(:new_params) do
      {
        user:
          {
            email: user.email,
            password: 'not_valid_password'
          }
      }
    end

    before do
      post '/api/v1/users/sign_in/', params: new_params, as: :json
    end

    it 'unauthorized' do
      expect(response).to be_unauthorized
    end

    it 'return errors upon failure' do
      expected_response = {
        error: 'Invalid login credentials. Please try again.'
      }.with_indifferent_access
      expect(json).to eq(expected_response)
    end
  end
end
