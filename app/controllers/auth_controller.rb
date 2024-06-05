require 'sinatra/base'
require 'json'
require_relative '../interactors/auth_interactor'

class AuthController < Sinatra::Base
  before do
    content_type :json
  end

  post '/login' do
    request_body = JSON.parse(request.body.read)
    username = request_body['username']
    password = request_body['password']

    begin
      AuthInteractor.login(username, password)
      { status: 200, message: "Login successful for user #{username}" }.to_json
    rescue AuthInteractor::AuthenticationError => e
      status 400
      { status: 400, error: "Login failed for user #{username}: #{e.message}" }.to_json
    end
  end

  post '/logout' do
    request_body = JSON.parse(request.body.read)
    username = request_body['username']

    if AuthInteractor.authenticated?(username)
      AuthInteractor.logout(username)
      { status: 200, message: "Logout successful for user #{username}" }.to_json
    else
      status 400
      { status: 400, error: "User #{username} is not logged in" }.to_json
    end
  end

  get '/status' do
    username = params['username']

    if AuthInteractor.authenticated?(username)
      { status: 200, message: "User #{username} is authenticated" }.to_json
    else
      status 401
      { status: 401, error: "User #{username} is not authenticated" }.to_json
    end
  end
end
