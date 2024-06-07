module AuthUtils
  def self.get_token(request)
    auth_header = request.env['HTTP_AUTHORIZATION']
    return nil unless auth_header && auth_header.start_with?('Bearer ')

    auth_header.split(' ').last
  end
end
