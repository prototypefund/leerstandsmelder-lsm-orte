# frozen_string_literal: true

require 'rails_helper'
require 'json'

RSpec.describe 'POST /api/v1/auth/sign_in', type: :request do
  let(:user) { FactoryBot.create(:user) }
  let(:url) { '/api/v1/auth/sign_in' }
  let(:params) do
    {
      email: user.email,
      password: user.password
    }
  end

  context 'when params are correct' do
    before do
      post url, params: params
    end

    it 'returns 200' do
      expect(response).to have_http_status(200)
    end

    it 'returns token in  header' do
      expect(response.headers['access-token']).to be_present
    end
  end

  context 'when login params are incorrect' do
    before { post url }

    it 'returns unauthorized status' do
      expect(response.status).to eq 401
    end
  end

  def login
    post api_user_session_path, params: { email: @current_user.email, password: 'password' }.to_json, headers: { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
  end

  def get_auth_params_from_login_response_headers(response)
    client = response.headers['client']
    token = response.headers['access-token']
    expiry = response.headers['expiry']
    token_type = response.headers['token-type']
    uid = response.headers['uid']

    {
      'access-token' => token,
      'client' => client,
      'uid' => uid,
      'expiry' => expiry,
      'token-type' => token_type
    }
  end
end

RSpec.describe 'DELETE /api/v1/auth/sign_out', type: :request do
  let(:url) { '/api/v1/auth/sign_out' }

  it 'returns 401, unauthorizted' do
    delete url
    expect(response).to have_http_status(401)
  end
end
