# Call OtpService external service to sign document remotely
class OtpService
  prepend SimpleCommand

  attr_reader :operation, :params, :http_status, :response, :url

  URL = "#{CONFIG.dig(:otpservice, :host)}/api/v1".freeze

  def initialize(operation:, params: {})
    @operation  = operation
    @params     = params
    @username   = Rails.application.credentials.otpservice.dig(Rails.env.to_sym, :username)
    @password   = Rails.application.credentials.otpservice.dig(Rails.env.to_sym, :password)
    raise 'You must set otpservice username and password before continue!' unless @username && @password

    @@auth_token ||= retrieve_auth_token
  end

  def call
    result = execute_operation
    # Se 401, può essere scaduto il token per cui si ritenta l'autenticazione
    if http_status == '401'
      @errors = SimpleCommand::Errors.new
      @@auth_token = retrieve_auth_token
      result = execute_operation
    end
    result
  end

  private

  attr_reader :username, :password
  cattr_accessor :auth_token

  def execute_operation
    response_body =
      case operation
      when :show, :create, :recreate then send operation, params
      when :auth then auth_token
      else raise "Operation #{operation} not valid!"
      end
    # log here operations...
    response_body
  end

  def show(attributes)
    unless attributes.is_a?(Hash)
      errors.add(:attributes, 'Invalid or missing params! Params must be an hash of attributes!')
    end
    errors.add(:attributes, 'Invalid or missing params! Set dossier_id param') unless attributes[:dossier_id].present?
    unless errors.present?
      @response = http_action :get, "#{URL}/dossiers/#{attributes[:dossier_id]}"
      body = JSON.parse(@response.body)
      @http_status = @response.code
      errors.add(operation, body) unless @http_status == '200'
      body
    end
  end

  def create(attributes, action_url: "#{URL}/dossiers")
    unless attributes.is_a?(Hash)
      errors.add(:attributes, 'Invalid or missing params! Params must be an hash of attributes!')
    end
    unless attributes[:customer_dossier_id].present?
      errors.add(:attributes, 'Invalid or missing params! Set customer_dossier_id param')
    end
    errors.add(:attributes, 'Invalid or missing params! Set recipients param') unless attributes[:recipients].present?
    if attributes[:recipients].present?
      attributes[:recipients].each do |recipient|
        unless recipient[:first_name].present?
          errors.add(:attributes, 'Invalid or missing params! Set recipient firstname param')
        end
        unless recipient[:last_name].present?
          errors.add(:attributes, 'Invalid or missing params! Set recipient lastname param')
        end
        unless recipient[:email].present?
          errors.add(:attributes, 'Invalid or missing params! Set recipient email param')
        end
        unless recipient[:phone_prefix].present?
          errors.add(:attributes, 'Invalid or missing params! Set recipient phone_prefix param')
        end
        unless recipient[:phone_number].present?
          errors.add(:attributes, 'Invalid or missing params! Set recipient phone_number param')
        end
        if /\A(\+|00).+\Z/ === recipient[:phone_number]
          errors.add(:attributes, 'Invalid phone_number param! It must not contain phone_prefix')
        end
        unless recipient[:language].present?
          errors.add(:attributes, 'Invalid or missing params! Set recipient language param')
        end
      end
    end

    unless attributes[:unsigned_document].present?
      errors.add(:attributes, 'Invalid or missing params! Set document params')
    end
    unless attributes.dig(:unsigned_document, :filename).present?
      errors.add(:attributes, 'Invalid or missing params! Set document filename param')
    end
    unless attributes.dig(:unsigned_document, :content).present?
      errors.add(:attributes, 'Invalid or missing params! Set document base64 content param')
    end
    unless attributes.dig(:unsigned_document, :sign_points).present?
      errors.add(:attributes, 'Invalid or missing params! Set sign points params')
    end
    if attributes.dig(:unsigned_document, :sign_points).present?
      attributes.dig(:unsigned_document, :sign_points).each do |sign_point|
        errors.add(:attributes, 'Invalid or missing params! Set sign point key param') unless sign_point[:key].present?
        unless sign_point[:label].present?
          errors.add(:attributes, 'Invalid or missing params! Set sign point label param')
        end
        unless sign_point[:page].present?
          errors.add(:attributes, 'Invalid or missing params! Set sign point page param')
        end
        errors.add(:attributes, 'Invalid or missing params! Set sign point top param') unless sign_point[:top].present?
        unless sign_point[:left].present?
          errors.add(:attributes, 'Invalid or missing params! Set sign point left param')
        end
      end
    end

    unless errors.present?
      # @response = http_post "#{URL}/dossiers", attributes
      @response = http_action :post, action_url, params: attributes
      body = JSON.parse(@response.body)
      @http_status = @response.code
      errors.add(operation, body) unless @http_status == '201'
      body
    end
  end

  def recreate(attributes)
    errors.add(:attributes, 'Invalid or missing params! Set dossier_id param') unless attributes[:dossier_id].present?
    create(attributes, action_url: "#{URL}/dossiers/#{attributes[:dossier_id]}/recreate")
  end

  def retrieve_auth_token
    errors.add(:username, 'Set username or password to use otp service!') unless username
    errors.add(:password, 'Set username or password to use otp service!') unless password
    _request_params = { email: username, password: password }
    @response = http_action :post, "#{URL}/authenticate", params: _request_params, authenticated: false
    @http_status = @response.code
    body = JSON.parse(@response.body)
    unless @http_status == '200'
      # errors.add(:authentication, "Invalid username or password! Status: #{@response.code}")
      errors.add(:authentication, body)
    end
    body['auth_token']
  end

  def http_action(method, url, params: {}, authenticated: true)
    raise "Method #{method} not supported!" unless %i[get post put].include? method

    @url = url
    uri = URI.parse(url)
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = (uri.scheme == 'https')
    request =
      case method
      when :get   then Net::HTTP::Get.new(uri.request_uri)
      when :post  then Net::HTTP::Post.new(uri.request_uri)
      when :put then Net::HTTP::Put.new(uri.request_uri)
      else raise("Cannot find the request for method #{method}")
      end
    request.body = params.to_json
    request['Content-type'] = 'application/json'
    request['Authorization'] = auth_token if authenticated
    http.request(request)
  end

  # Custom exception
  # class ProviderError < StandardError; end
  # class AuthorizationError < StandardError; end
end

# How to try:
#
# service=OtpService.call(operation: :show, params: { dossier_id: 1 })
#
