class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception, unless: :json_request?
  protect_from_forgery with: :null_session, if: :json_request? # return null session when API call
  before_action :set_locale, :current_organization

  # Non funzionano più i moduli concerns, oscura il before_action, verificare
  # include JwtAuthenticable
  before_action :authenticate_request, if: :json_request?

  respond_to :html, :json

  protected

  rescue_from ::CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.html { redirect_to root_url, :alert => exception.message }
      format.json { render json: { error: exception.message }, status: :forbidden }
    end
  end

  def current_ability
    @current_ability ||= ::Ability.new(current_admin_user)
  end

  def current_organization
    @current_organization ||=
      if ENV['ORGANIZATION'].present?
        Organization.find(ENV['ORGANIZATION'])
      else
        subdomain = parsed_subdomain
        if subdomain.present?
          Organization.find_by_domain(subdomain)
        end
      end
  end

  # def current_organization
  #   Organization.find(ENV['ORGANIZATION'])
  # rescue ActiveRecord::NotFound
  #   raise "Please set ORGANIZATION env with the id"
  # end

  def json_request?
    request.format.json?
  end

  # Set locale by param in the query string
  def set_locale
    I18n.locale =
      if json_request?
        # if we got an empy header e.g. we are running features we serve the default locale
        # this way we also preserve the entire admin section from being localized in IT!
        get_language_header.present? ? get_language_header.first : I18n.default_locale
      else
        if params[:locale]
          session[:locale] = params[:locale]
        else
          session[:locale] ||= I18n.default_locale
        end
        session[:locale]
      end
  end

  # Set locale by http header
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

  # This should authenticate only api calls (devise included)
  def authenticate_request
    return true if /\/admin\// === request.referrer
    @current_user = AuthorizeApiRequest.call(request.headers).result
    render json: { error: 'Not Authorized' }, status: 401 unless @current_user
  end

  def parsed_subdomain
    parsed_subdomains = request.subdomains.reject do |subdomain|
      %w[www api].include?(subdomain)
    end
    parsed_subdomains.join('.')
  end

  attr_reader :current_user
end
