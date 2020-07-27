class UsersController < ApplicationController
  helper VueHelper

  layout 'users'

  def index
    organization_uuid = params.permit(:uuid)[:uuid]
    @current_organization = Organization.find_by_uuid(organization_uuid) if organization_uuid.present?
  end

end
