require 'bcrypt'
require 'jwt'
require_relative '../exceptions/auth_exception'

class AuthInteractor
  USERS = {
    'admin' => BCrypt::Password.create('password')
  }.freeze

  SECRET_KEY = 'your_secret_key'

  class << self
    def login(username, password)
      unless USERS[username] && BCrypt::Password.new(USERS[username]) == password
        raise AuthenticationError, 'Invalid username or password'
      end

      generate_token(username)
    end

    def validate_token(token)
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
      raise AuthenticationError, 'Invalid token'
    end
  end
end
