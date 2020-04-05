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
    permitted << :organization_id if current_admin_user.is_root? || params[:action] == 'create'
    permitted
  end

  controller do
    def scoped_collection
      myscope = super
      myscope = myscope.includes :organization, :category, :course, :room, :trainer
      myscope
    end
  end

  index do
    selectable_column
    id_column
    if current_admin_user.is_root?
      column(:organization)
    end
    column(:category)
    column(:course)
    column(:room)
    column(:trainer)
    column(:event_day) { |obj|  obj.localized_event_day }
    column(:event_time) { |obj|  obj.event_time_short }
    column(:state) {|obj| span obj.localized_state, class: "status_tag #{obj.state}" }
    column(:created_at)
    column(:updated_at)
    actions
  end

  filter :organization    , if: proc { current_admin_user.is_root? }
  filter :category        , collection: proc { current_admin_user.categories }
  filter :course          , collection: proc { current_admin_user.courses }
  filter :room            , collection: proc { current_admin_user.rooms }
  filter :trainer         , collection: proc { current_admin_user.trainers }
  filter :event_day       , as: :select, collection: CourseSchedule.localized_event_days
 #filter :event_time
  filter :state           , as: :select, collection: CourseSchedule.localized_states
  filter :created_at
  filter :updated_at
end
