class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, unless: :json_request?
  protect_from_forgery with: :null_session, if: :json_request? # return null session when API call
  before_action :set_locale, :current_organization

  # Non funzionano più i moduli concerns, oscura il before_action, verificare
  # include JwtAuthenticable
  before_action :authenticate_request, if: :json_request?

  respond_to :html, :json

  protected

  def current_organization
    @current_organization ||= Organization.find(ENV['ORGANIZATION'])
  end

  # def current_organization
  #   Organization.find(ENV['ORGANIZATION'])
  # rescue ActiveRecord::NotFound
  #   raise "Please set ORGANIZATION env with the id"
  # end

  def json_request?
    request.format.json?
  end

  def set_locale
    # if we got an empy header e.g. we are running features we serve the default locale
    # this way we also preserve the entire admin section from being localized in IT!
    I18n.locale = get_language_header.present? ? get_language_header.first : I18n.default_locale
  end

  def get_language_header
    accepts_languages       = request.env['HTTP_ACCEPT_LANGUAGE'] || 'en'
    languages               = HTTP::Accept::Languages.parse(accepts_languages) rescue [HTTP::Accept::Languages::LanguageRange.new('en')]
    available_locales       = I18n.available_locales.map(&:to_s).reverse
    available_localizations = HTTP::Accept::Languages::Locales.new(available_locales)
    desired_localizations   = available_localizations & languages
    # IE headers fix for IT locale!
    return ['it'] if request.env['HTTP_ACCEPT_LANGUAGE'] == 'it-IT'
    # if desired_localizations is an empty array this means
    # that the user does not have any available language configured on
    # the browser that matches any of our locales ['it', 'en']
    # so we just fallback to EN by serving the ['en'] array
    desired_localizations.empty? ? ['en'] : desired_localizations
  end

  def authenticate_request
    #require_relative Rails.root.join "app/services/authorize_api_request.rb"
    @current_user = AuthorizeApiRequest.call(request.headers).result
    render json: { error: 'Not Authorized' }, status: 401 unless @current_user
  end

  attr_reader :current_user
end
