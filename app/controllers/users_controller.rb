class UsersController < ApplicationController
  helper VueHelper
  # skip_before_action :basic_authenticate
  layout 'users'

  def index
  end

end
