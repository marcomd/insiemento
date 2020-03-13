ActiveAdmin.register Course do
  menu parent: 'courses_management', if: proc{ can?(:read, Course) }

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :name, :description, :start_booking_hours, :end_booking_minutes
  #
  # or

  permit_params do
    permitted = [:category_id, :name, :description, :start_booking_hours, :end_booking_minutes, :state]
    # permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end

  controller do
    def scoped_collection
      myscope = super
      myscope = myscope.includes :organization, :category
      myscope
    end
  end
  
end
