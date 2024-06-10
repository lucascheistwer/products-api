require 'rspec'
require 'rack/test'
require_relative '../../controllers/auth_controller'
require_relative '../../interactors/auth_interactor'

RSpec.describe AuthController do
  include Rack::Test::Methods

  def app
    AuthController.new
  end

  describe 'POST /auth/login' do
    context 'with valid credentials' do
      it 'returns a success message and token' do
        post '/auth/login', { username: 'admin', password: 'password' }.to_json,
             { 'CONTENT_TYPE' => 'application/json' }
        expect(last_response.status).to eq(200)
        response_body = JSON.parse(last_response.body)
        expect(response_body['message']).to include('Login successful')
        expect(response_body).to have_key('token')
      end
    end

    context 'with invalid credentials' do
      it 'returns an error message' do
        post '/auth/login', { username: 'admin', password: 'wrongpassword' }.to_json,
             { 'CONTENT_TYPE' => 'application/json' }
        expect(last_response.status).to eq(400)
        response_body = JSON.parse(last_response.body)
        expect(response_body['error']).to include('Login failed')
      end
    end
  end

  describe 'GET /auth/status' do
    context 'with a valid token' do
      it 'returns a success message' do
        token = AuthInteractor.login('admin', 'password')
        header 'Authorization', "Bearer #{token}"
        get '/auth/status'
        expect(last_response.status).to eq(200)
        response_body = JSON.parse(last_response.body)
        expect(response_body['message']).to include('User admin is authenticated')
      end
    end

    context 'with an invalid token' do
      it 'returns an error message' do
        header 'Authorization', 'Bearer invalidtoken'
        get '/auth/status'
        expect(last_response.status).to eq(401)
        response_body = JSON.parse(last_response.body)
        expect(response_body['error']).to include('Empty or invalid token')
      end
    end
  end
end
