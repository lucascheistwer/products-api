# app/app.rb
require 'sinatra/base'
require_relative 'controllers/auth_controller'

class MainApplication < Sinatra::Base
  use AuthController

  run! if app_file == $0
end
