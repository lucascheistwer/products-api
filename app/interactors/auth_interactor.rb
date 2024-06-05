require 'bcrypt'

class AuthInteractor
  class AuthenticationError < StandardError; end

  USERS = {
    'admin' => BCrypt::Password.create('password')
  }.freeze

  @authenticated_users = {}

  class << self
    attr_accessor :authenticated_users

    def login(username, password)
      unless USERS[username] && BCrypt::Password.new(USERS[username]) == password
        raise AuthenticationError, 'Invalid username or password'
      end

      authenticated_users[username] = true
    end

    def logout(username)
      authenticated_users.delete(username)
    end

    def authenticated?(username)
      authenticated_users[username]
    end
  end
end
