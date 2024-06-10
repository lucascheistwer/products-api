require 'sinatra/base'
require_relative 'controllers/auth_controller'
require_relative 'controllers/products_controller'

class MainApplication < Sinatra::Base
  use AuthController
  use ProductsController

  set :public_folder, File.dirname(__FILE__) + '/public'

  before '/authors' do
    expires 86_400, :public, :must_revalidate
  end

  before '/openapi.yaml' do
    cache_control :no_cache
  end

  run! if app_file == $0
end
