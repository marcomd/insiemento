class Api::Ui::BaseController < ApplicationController
  respond_to :json

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

  rescue_from ActionController::ParameterMissing, Api::BadRequestError do |exception|
    add_system_log exception.message, log_level: 'warning'
    respond_to do |format|
      format.json { render json: { error: exception.message }, status: :bad_request }
    end
  end

  rescue_from Api::ConflictError do |exception|
    add_system_log exception.message, log_level: 'warning'
    respond_to do |format|
      format.json { render json: { error: exception.message }, status: 409 }
    end
  end

  private

  def set_organization
    @organization = current_organization || current_user.organization || raise(ActionController::RoutingError, 'Organization must exist!')
  end

  def add_system_log(message, log_level:)
    # TODO: complete with the project's system log
    puts "#{log_level}: #{message}" if Rails.env.development?
  end

  def simulate_delay_for_development
    sleep(rand(0.0..1.5)) if Rails.env.development?
  end


end
