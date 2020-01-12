ActiveAdmin.register Trainer do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :firstname, :lastname, :nickname, :bio
  #
  # or

  permit_params do
    permitted = [:firstname, :lastname, :nickname, :bio, :state]
    # permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end
  
end
