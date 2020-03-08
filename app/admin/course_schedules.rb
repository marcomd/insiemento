ActiveAdmin.register CourseSchedule do
  menu parent: 'courses_management', if: proc{ can?(:read, CourseSchedule) }

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :course_id, :room_id, :trainer_id, :event_day, :event_time
  #
  # or

  permit_params do
    permitted = [:category_id, :course_id, :room_id, :trainer_id, :event_day, :event_time, :state]
    # permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end

  controller do
    def scoped_collection
      myscope = super
      myscope = myscope.includes :organization, :course, :room, :trainer
      myscope
    end
  end
end
