require 'rails_helper'
require "json"

RSpec.describe 'POST /api/v1/users/sign_in', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:url) { '/api/v1/users/sign_in' }
  let(:params) do
    {
      :format => 'json',
      api_user: {
        email: user.email,
        password: user.password
      }
    }
  end

  context 'when params are correct' do
    before do
      post url, params: params
    end

    it 'returns 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns JTW token in authorization header' do
      expect(response.headers['Authorization']).to be_present
    end

    it 'returns valid JWT token' do
      
      decoded_token = JWT.decode(response.headers['Authorization'].split(' ').last, Rails.application.credentials.devise_jwt_secret_key, true)
      expect(decoded_token.first['sub']).to be_present
    end
  end

  context 'when login params are incorrect' do
    before { post url }
    
    it 'returns unauthorized status' do
      expect(response.status).to eq 401
    end
  end
end

RSpec.describe 'DELETE /api/v1/users/sign_out', type: :request do
  let(:url) { '/api/v1/users/sign_out' }
  let(:params) do
    {
      :format => 'json'
    }
  end

  it 'returns 204, no content' do
    delete url, params: params
    expect(response).to have_http_status(204)
  end
end