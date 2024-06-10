require 'bcrypt'
require 'jwt'
require_relative '../exceptions/auth_exception'

class AuthInteractor
  USERS = {
    'admin' => BCrypt::Password.create('password')
  }.freeze

  SECRET_KEY = ENV['JWT_SECRET_KEY']

  class << self
    def login(username, password)
      unless USERS[username] && BCrypt::Password.new(USERS[username]) == password
        raise AuthenticationError, 'Invalid username or password'
      end

      generate_token(username)
    end

    def validate_request_token(request)
      token = get_token(request)
      decoded_token = decode_token(token)
      raise AuthenticationError, 'Token has expired' if Time.at(decoded_token['exp']) < Time.now

      decoded_token['username']
    end

    private

    def generate_token(username)
      exp = Time.now.to_i + 3600
      payload = { username: username, exp: exp }
      JWT.encode(payload, SECRET_KEY, 'HS256')
    end

    def decode_token(token)
      decoded = JWT.decode(token, SECRET_KEY, true, { algorithm: 'HS256' })
      decoded.first
    rescue JWT::DecodeError
      raise AuthenticationError, 'Empty or invalid token'
    end

    def get_token(request)
      auth_header = request.env['HTTP_AUTHORIZATION']
      return nil unless auth_header && auth_header.start_with?('Bearer ')

      auth_header.split(' ').last
    end
  end
end
