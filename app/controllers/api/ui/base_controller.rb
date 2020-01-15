class API::Ui::BaseController < ApplicationController
  include JWTAuthenticable
  protect_from_forgery if: :json_request # return null session when API call

  respond_to :json

  before_action :authenticate_request, if: :json_request

  attr_reader :current_user

  # See also GuestControllable...
  rescue_from ActiveRecord::RecordNotFound, ActionController::RoutingError do |exception|
    add_system_log exception.message, log_level: 'info'
    respond_to do |format|
      format.json { render json: { error: exception.message }, status: :not_found }
    end
  end
  rescue_from ActiveRecord::RecordInvalid do |exception|
    add_system_log exception.message, log_level: 'warning'
    respond_to do |format|
      format.json { render json: { error: exception.message }, status: :unprocessable_entity }
    end
  end
  rescue_from ActionController::ParameterMissing do |exception|
    add_system_log exception.message, log_level: 'warning'
    respond_to do |format|
      format.json { render json: { error: exception.message }, status: 409 }
    end
  end

  private

  def add_system_log(message, log_level:)
    # TODO: complete with the project's system log
    puts "#{log_level}: #{message}" if Rails.env.development?
  end

  def json_request
    request.format.json?
  end

  def simulate_delay_for_development
    sleep(rand(0.0..1.5)) if Rails.env.development?
  end

  def localized_attr_name
    @localized_attr_name ||= I18n.locale.to_s.downcase == 'it' ? :name_it : :name
  end

  #
  # Metodi di Papertrail per salvare le modifiche e scrivere il customer loggato che le ha fatte
  #
  # def info_for_paper_trail
  #   {whodunnit_type: 'Customer'}
  # end
  #
  # def user_for_paper_trail
  #   current_customer.id if current_customer
  # end

end
