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
    permitted << :organization_id if current_admin_user.is_root?
    permitted
  end

  controller do
    def scoped_collection
      myscope = super
      myscope = myscope.includes :organization, :category
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
    column(:name)
    column(:description)
    column(:start_booking_hours)
    column(:end_booking_minutes)
    column(:state) {|obj| span obj.localized_state, class: "status_tag #{obj.state}" }
    column(:created_at)
    column(:updated_at)
    actions
  end

  filter :organization    , if: proc { current_admin_user.is_root? }
  filter :category        , collection: proc { current_admin_user.categories }
  filter :course_schedule , collection: proc { current_admin_user.course_schedules }
  filter :room            , collection: proc { current_admin_user.rooms }
  filter :trainer         , collection: proc { current_admin_user.trainers }
  filter :name
  filter :description
  filter :start_booking_hours
  filter :end_booking_minutes
  filter :state       , as: :select, collection: Course.localized_states
  filter :created_at
  filter :updated_at
end
