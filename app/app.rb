require 'sinatra/base'
require_relative 'controllers/auth_controller'
require_relative 'controllers/products_controller'

class MainApplication < Sinatra::Base
  use AuthController
  use ProductsController

  run! if app_file == $0
end
