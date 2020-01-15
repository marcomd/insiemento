class AuthorizeApiRequest
  prepend SimpleCommand

  HEADER_NAME = 'X-Auth-Token'

  def initialize(headers = {})
    require_relative Rails.root.join 'lib/fg/json_web_token.rb'
    @headers = headers
  end

  def call
    customer
  end

  private

  attr_reader :headers

  def customer
    @customer ||= Customer.find(decoded_auth_token[:customer_id]) if decoded_auth_token
    @customer || errors.add(:token, 'Invalid token') && nil
  end

  def decoded_auth_token
    @decoded_auth_token ||= JsonWebToken.decode(http_auth_header)
  end

  def http_auth_header
    if headers[HEADER_NAME].present?
      return headers[HEADER_NAME].split(' ').last
    else
      errors.add(:token, 'Missing token')
    end
    nil
  end
end
