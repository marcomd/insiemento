ActiveAdmin.register Room do
  menu parent: 'gym_management', if: proc{ can?(:read, Room) }

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :course_id, :name, :max_attendees
  #
  # or

  permit_params do
    permitted = [:name, :max_attendees, :state]
    # permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end

  controller do
    def scoped_collection
      myscope = super
      myscope = myscope.includes :organization
      myscope
    end
  end
end
