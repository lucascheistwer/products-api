require 'sinatra/base'
require 'json'
require_relative '../interactors/auth_interactor'
require_relative '../exceptions/auth_exception'
require_relative 'base_controller'

class AuthController < BaseController
  post '/auth/login' do
    request_body = JSON.parse(request.body.read)
    username = request_body['username']
    password = request_body['password']

    begin
      token = AuthInteractor.login(username, password)
      { status: 200, message: "Login successful for user #{username}", token: token }.to_json
    rescue AuthenticationError => e
      status 400
      { status: 400, error: "Login failed for user #{username}: #{e.message}" }.to_json
    end
  end

  get '/auth/status' do
    username = AuthInteractor.validate_request_token(request)
    { status: 200, message: "User #{username} is authenticated" }.to_json
  rescue AuthenticationError => e
    status 401
    { status: 401, error: e.message }.to_json
  end
end
