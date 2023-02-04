class UsersController < ApplicationController
  helper VueHelper

  layout 'users'

  # Usefull to set organization only on the frontend, for preview or similar purposes, without change
  # current_organization in the application controller
  def index
    uuid = params.permit(:uuid)[:uuid]
    @current_organization = Organization.find_by(uuid:) if uuid.present?
  end
end
