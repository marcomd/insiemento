ActiveAdmin.register User do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :firstname, :lastname, :email, :birtdate, :gender
  #
  # or

  permit_params do
    permitted = [:firstname, :lastname, :email, :birtdate, :gender, :state]
    # permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end
  
end
