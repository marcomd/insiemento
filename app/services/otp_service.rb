# Call OtpService external service to sign document remotely
#
# Example of usage:
#
# service = OtpService.call(operation: :show, params: { dossier_id: 1 })
#
class OtpService
  prepend SimpleCommand

  attr_reader :operation, :params, :http_status, :response, :url

  URL = "#{CONFIG.dig(:otpservice, :host)}/api/v1".freeze

  @@auth_token = nil # rubocop:disable Style/ClassVars

  def initialize(operation:, params: {})
    @operation  = operation
    @params     = params
    @username   = Rails.application.credentials.otpservice.dig(Rails.env.to_sym, :username)
    @password   = Rails.application.credentials.otpservice.dig(Rails.env.to_sym, :password)
    raise('You must set otpservice username and password before continue!') unless @username && @password

    @@auth_token ||= retrieve_auth_token # rubocop:disable Style/ClassVars
  end

  def call
    result = execute_operation
    # Se 401, può essere scaduto il token per cui si ritenta l'autenticazione
    if http_status == '401'
      @errors = SimpleCommand::Errors.new
      @@auth_token = retrieve_auth_token # rubocop:disable Style/ClassVars
      result = execute_operation
    end
    result
  end

  private

  attr_reader :username, :password

  cattr_accessor :auth_token

  def execute_operation
    case operation
    when :show, :create, :recreate then send(operation)
    when :auth then auth_token
    else raise("Operation #{operation} not valid!")
    end
    # log here operations...
  end

  def show
    errors.add(:attributes, 'Invalid or missing params! Params must be an hash of attributes!') unless params.is_a?(Hash)
    errors.add(:attributes, 'Invalid or missing params! Set dossier_id param') if params[:dossier_id].blank?
    return if errors.present?
    @response = http_action(:get, "#{URL}/dossiers/#{params[:dossier_id]}")
    body = JSON.parse(@response.body)
    @http_status = @response.code
    errors.add(operation, body) unless @http_status == '200'
    body
  end

  def create(action_url: "#{URL}/dossiers")
    errors.add(:attributes, 'Invalid or missing params! Params must be an hash of attributes!') unless params.is_a?(Hash)
    errors.add(:attributes, 'Invalid or missing params! Set customer_dossier_id param') if params[:customer_dossier_id].blank?
    recipient_checks
    document_checks

    return if errors.present?

    @response = http_action(:post, action_url, params:)
    body = JSON.parse(@response.body)
    @http_status = @response.code
    errors.add(operation, body) unless @http_status == '201'
    body
  end

  def recipient_checks
    errors.add(:attributes, 'Invalid or missing params! Set recipients param') if params[:recipients].blank?

    return if params[:recipients].blank?

    recipient_attributes = [:first_name, :last_name, :email, :phone_prefix, :phone_number, :language]
    params[:recipients].each do |recipient|
      recipient_attributes.each do |attribute|
        errors.add(:attributes, "Invalid or missing params! Set recipient #{attribute} param") if recipient[attribute].blank?
      end
      errors.add(:attributes, 'Invalid phone_number param! It must not contain phone_prefix') if /\A(\+|00).+\Z/ === recipient[:phone_number]
    end
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  def document_checks
    errors.add(:attributes, 'Invalid or missing params! Set document params') if params[:unsigned_document].blank?
    [:filename, :content, :sign_points].each do |attribute|
      errors.add(:attributes, "Invalid or missing params! Set document #{attribute} param") if params.dig(:unsigned_document, attribute).blank?
    end

    return if params.dig(:unsigned_document, :sign_points).blank?

    sign_point_attributes = [:key, :label, :page, :top, :left]
    params.dig(:unsigned_document, :sign_points).each do |sign_point|
      sign_point_attributes.each do |attribute|
        errors.add(:attributes, "Invalid or missing params! Set sign point #{attribute} param") if sign_point[attribute].blank?
      end
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  def recreate
    errors.add(:attributes, 'Invalid or missing params! Set dossier_id param') if params[:dossier_id].blank?
    create(action_url: "#{URL}/dossiers/#{params[:dossier_id]}/recreate")
  end

  def retrieve_auth_token
    errors.add(:username, 'Set username or password to use otp service!') unless username
    errors.add(:password, 'Set username or password to use otp service!') unless password
    request_params = { email: username, password: }
    @response = http_action(:post, "#{URL}/authenticate", params: request_params, authenticated: false)
    @http_status = @response.code
    body = JSON.parse(@response.body)
    unless @http_status == '200'
      # errors.add(:authentication, "Invalid username or password! Status: #{@response.code}")
      errors.add(:authentication, body)
    end
    body['auth_token']
  end

  def http_action(method, url, params: {}, authenticated: true)
    raise("Method #{method} not supported!") unless %i[get post put].include?(method)

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
# rubocop:enable Metrics/AbcSize
