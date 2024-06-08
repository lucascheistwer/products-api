require 'sinatra/base'
require 'zlib'

class BaseController < Sinatra::Base
  before do
    content_type :json
  end

  after do
    if request.env['HTTP_ACCEPT_ENCODING']&.include?('gzip') && !response['Content-Encoding']
      response.body = compress(response.body)
      response['Content-Encoding'] = 'gzip'
    end
  end

  private

  def compress(data)
    gz = Zlib::GzipWriter.new(StringIO.new)
    gz.write(data)
    gz.close.string
  end
end
