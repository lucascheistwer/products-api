require 'rspec'
require 'rack/test'
require 'dotenv/load'
require_relative '../../controllers/products_controller'
require_relative '../../interactors/auth_interactor'

RSpec.describe ProductsController do
  include Rack::Test::Methods

  def app
    ProductsController.new
  end

  let(:token) { AuthInteractor.login('admin', 'password') }

  describe 'POST /products' do
    context 'with a valid token' do
      it 'creates a product asynchronously' do
        header 'Authorization', "Bearer #{token}"
        post '/products', { name: 'Product1' }.to_json, { 'CONTENT_TYPE' => 'application/json' }
        expect(last_response.status).to eq(201)
        response_body = JSON.parse(last_response.body)
        expect(response_body['message']).to eq('Product being created asynchronously')
      end
    end

    context 'with an invalid token' do
      it 'returns an error message' do
        header 'Authorization', 'Bearer invalidtoken'
        post '/products', { name: 'Product1' }.to_json, { 'CONTENT_TYPE' => 'application/json' }
        expect(last_response.status).to eq(401)
        response_body = JSON.parse(last_response.body)
        expect(response_body['error']).to include('Empty or invalid token')
      end
    end
  end

  describe 'GET /products' do
    context 'with a valid token' do
      it 'returns the list of products' do
        header 'Authorization', "Bearer #{token}"
        get '/products'
        expect(last_response.status).to eq(200)
        response_body = JSON.parse(last_response.body)
        expect(response_body).to have_key('products')
      end
    end

    context 'with an invalid token' do
      it 'returns an error message' do
        header 'Authorization', 'Bearer invalidtoken'
        get '/products'
        expect(last_response.status).to eq(401)
        response_body = JSON.parse(last_response.body)
        expect(response_body['error']).to include('Empty or invalid token')
      end
    end
  end
end
