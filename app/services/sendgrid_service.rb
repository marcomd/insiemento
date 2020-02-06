#
# Interaction manager with sendgrid external service
# You must me registered https://api.sendgrid.com and have an api key to use this service
# Create your dynamic templates, get ids and store in config/sendgrid/templates.yml
# This class is poor but it works and for now it is enought
#
class SendgridService
  prepend SimpleCommand

  attr_reader :status_code

  def initialize(operation, params={})
    @operation  = operation
    @params     = params
  end

  def call
    execute_operation
  end

  private

  attr_reader :operation, :params

  def execute_operation
    response_body =
      case operation
      when :send_email, :evaluate_template then send operation, params
      when :auth then auth_token
      else
        errors.add :base,"Operation #{operation} not valid!"
        nil
      end
    response_body
  end

  #
  # Get html template
  #
  def evaluate_template
    template_name = params[:template_name]
    raise 'Template name must be set!' unless template_name.present?
    template_id = get_remote_template_id(template_name)
    @status_code, body = retrieve_single_template(template_id)
    if @status_code == 200
      raw_content = body['versions'][0]['html_content']
      # evalutate template with handlebars
      hbs = Handlebars::Handlebars.new
      mail_html_content = hbs.compile(raw_content).call(dynamic_template_data)
    else
      errors.add :base, body
      mail_html_content = nil
    end

    mail_html_content
  end

  #
  # Get remote template id by method_name
  #
    def get_remote_template_id(mailer)
    YAML.load(ERB.new(File.read("#{Rails.root}/config/sendgrid/templates.yml")).result).fetch(mailer.to_s)
  end

  #
  # Recipients and Lists
  #
  def retrieve_all_lists
    get(method_name: __method__)
  end

  def retrieve_all_custom_fields
    get(method_name: __method__)
  end

  def create_list(list_name)
    post(method_name: __method__, payload: { name: list_name })
  end

  def add_recipients(recipients)
    post(method_name: __method__, payload: recipients)
  end

  def add_recipients_ids_to_a_list(list_name:, recipients:)
    list_id = LISTS[list_name.to_sym]
    post(method_name: __method__, payload: recipients, params: {'_list_id' => list_id})
  end

  #
  # Get single remote template
  #
  def retrieve_single_template(template_id)
    get(method_name: __method__, params: {'_template_id' => template_id})
  end

  #
  # Send email with Sendgrid API V3
  # 
  # @param [Object] from: {email: '', name: ''}
  # @param [String] to:
  # @param [String] template_id:
  # @return [Boolean, String]
  #
  # example:
  # success, message = SendgridService.call(:send_email, { from: {email: ''}, to: '', template_id: '' })
  # => [true, 'Email Sent']
  #
  def send_email(**args)
    return [false, required_params_not_filled(args)] if required_params_not_filled(args).any?
    payload = send_email_payload(args)
    payload.merge!(sandbox_mode) if is_development? && !args[:debug]
    payload = faking_recipients(payload) if is_not_production? && !args[:debug]
    @status_code, body = post(method_name: __method__, payload: payload)
    unless request_succeded?(@status_code)
      errors.add :base, body
    end
    body
  end

  def required_params_not_filled(**args)
    params_not_filled = [:from, :to, :template_id].select{|p| args[p].nil?}
    {}.tap do |error_messages|
      params_not_filled.each do |param|
        error_messages[param] = "#{param} is required"
      end
    end
  end

  def send_email_payload(**args)
    to_array = args[:to].is_a?(String) ? [args[:to]] : args[:to]
    cc_array = args[:cc].is_a?(String) ? [args[:cc]] : args[:cc]
    bcc_array = args[:bcc].is_a?(String) ? [args[:bcc]] : args[:bcc]
    {
      from: args[:from],
      reply_to: args[:reply_to],
      personalizations: [
        {
          to: (to_array.map{ |mail|
            {email: mail}
          } if to_array),
          bcc: (bcc_array.map{ |mail|
            {email: mail}
          } if bcc_array),
          cc: (cc_array.map{ |mail|
            {email: mail}
          } if cc_array),
          dynamic_template_data: args[:dynamic_template_data]
        }.compact
      ],
      attachments: args[:attachments],
      template_id: args[:template_id]
    }.compact
  end

  def sandbox_mode
    {
      mail_settings: {
        sandbox_mode: {
          enable: true
        }
      }
    }
  end

  def endpoints
    {
      retrieve_all_lists: 'contactdb/lists',
      retrieve_all_custom_fields: 'contactdb/custom_fields',
      retrieve_single_template: 'templates/_template_id',
      create_list: 'contactdb/lists',
      add_recipients_ids_to_a_list: 'contactdb/lists/_list_id/recipients',
      add_recipients: 'contactdb/recipients',
      send_email: 'mail/send'
    }
  end

  def presets
    {
      # From Sendgrid doc:
      # The rate limit is three requests every 2 seconds.
      # You can upload 1000 contacts per request. So the maximum upload rate is 1500 recipients per second.
      add_recipients: lambda { sleep(1) }
    }
  end

  def post(method_name:, payload:, params: nil)
    endpoint = endpoints[method_name.to_sym]
    endpoint = (endpoint.gsub(/\w+/) { |m| params.fetch(m,m)}) if params
    presets[method_name.to_sym].call if presets[method_name.to_sym]
    request(url: endpoint, payload: payload, method: :post)
  end

  def get(method_name:, payload: nil, params: nil)
    endpoint = endpoints[method_name.to_sym]
    endpoint = (endpoint.gsub(/\w+/) { |m| params.fetch(m,m)}) if params
    request(url: endpoint, payload: payload, method: :get)
  end

  def request(url:, payload:, method:)
    response = begin
      RestClient::Request.execute(
        method: method,
        url: [CONFIG.dig(:sendgrid, :apipath), url].join('/'),
        payload: (payload.to_json if payload),
        headers: { authorization: "Bearer #{Rails.application.credentials.sendgrid.dig(:apikey)}", 'Content-Type': 'application/json' }
      )
      rescue RestClient::ExceptionWithResponse => e
        e.response
      end
    body = JSON.parse(response.body) rescue {}
    payload_without_attachments = strip_attachments(payload) if payload
    log_request(payload_without_attachments, response)
    return response.code, body
  end

  def request_succeded?(code)
    [200, 202].include?(code)
  end

  def strip_attachments(payload)
    if payload.kind_of?(Array)
      # if it's an array don't search for attachments (e.g. SendgridSyncJob)
      payload
    else
      payload.fetch(:attachments, []).map do |attachment|
        attachment[:content] = 'Stripped'
      end && payload
    end
  end

  def faking_recipients(payload)
    if payload.kind_of?(Array)
      payload
    else
      payload[:personalizations].map do |p_hash|
        p_hash[:to]  = [{email: Rails.application.credentials.email.dig(:recipient_for_interceptor)}] if p_hash[:to]
        p_hash[:bcc] = nil if p_hash[:bcc]
        p_hash[:cc]  = nil if p_hash[:cc]
        if p_hash[:dynamic_template_data] && p_hash[:dynamic_template_data][:subject]
          p_hash[:dynamic_template_data][:subject] = p_hash[:dynamic_template_data][:subject].prepend('[SENDGRID_TEST] ')
        end
      end && payload
    end
  end

  def log_request(payload, response)
    SystemLog.create!(message: "payload:#{payload} url:#{response.request.url} status:#{response.code}")
  end

  def is_development?
    Rails.env.development?
  end

  def is_not_production?
    !Rails.env.production?
  end

end
