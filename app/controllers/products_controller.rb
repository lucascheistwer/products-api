require 'sinatra/base'
require 'json'
require_relative '../interactors/products_interactor'
require_relative '../interactors/auth_interactor'
require_relative 'base_controller'

class ProductsController < BaseController
  post '/products' do
    request_body = JSON.parse(request.body.read)
    product_name = request_body['name']
    begin
      AuthInteractor.validate_request_token(request)
      product = ProductsInteractor.create_product(product_name)
      status 201
      { product: product }.to_json
    rescue AuthenticationError => e
      status 401
      { status: 401, error: e.message }.to_json
    end
  end

  get '/products' do
    AuthInteractor.validate_request_token(request)
    products = ProductsInteractor.get_products
    { products: products }.to_json
  rescue AuthenticationError => e
    status 401
    { status: 401, error: e.message }.to_json
  end
end
