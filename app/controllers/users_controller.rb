class UsersController < ApplicationController
  helper VueHelper

  layout 'users'

  # Usefull to set organization only on the frontend, for preview or similar purposes, without change
  # current_organization in the application controller
  def index
    organization_uuid = params.permit(:uuid)[:uuid]
    @current_organization = Organization.find_by_uuid(organization_uuid) if organization_uuid.present?
  end

end
