ActiveAdmin.register CourseEvent do
  menu parent: 'courses_management', if: proc{ can?(:read, CourseEvent) }

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :course_id, :room_id, :trainer_id, :course_schedule_id, :event_date
  #
  # or

  permit_params do
    permitted = [:category_id, :course_id, :room_id, :trainer_id, :course_schedule_id, :event_date, :state]
    permitted << :organization_id if current_admin_user.is_root?
    permitted
  end

  controller do
    def scoped_collection
      myscope = super
      myscope = myscope.includes :organization, :category, :course, :room, :trainer, :course_schedule
      myscope
    end

    def show
      @course_event = CourseEvent.includes(attendees: :user).find(params[:id])
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
    column(:course_schedule)
    column(:event_date)
    column(:state) {|obj| span obj.localized_state, class: "status_tag #{obj.state}" }
    column(:created_at)
    column(:updated_at)
    actions
  end

  filter :organization, if: proc { current_admin_user.is_root? }
  filter :category    , collection: proc { current_admin_user.categories }
  filter :course      , collection: proc { current_admin_user.courses }
  filter :room        , collection: proc { current_admin_user.rooms }
  filter :trainer     , collection: proc { current_admin_user.trainers }
  filter :user        , collection: proc { current_admin_user.users }
  filter :state       , as: :select, collection: CourseEvent.localized_states
  filter :event_date
  filter :created_at
  filter :updated_at

  show do |course_event|
    columns do
      column do
        attributes_table do
          if current_admin_user.is_root?
            column(:organization)
          end
          row(:category)
          row(:course)
          row(:room)
          row(:trainer)
          row(:course_schedule)
          row(:event_date)
          row(:state) {|obj| span obj.localized_state, class: "status_tag #{obj.state}" }
          row(:created_at)
          row(:updated_at)
        end
      end
      column do
        panel "#{Attendee.model_name.human(count: 2)} #{course_event.attendees.count} / #{course_event.room.max_attendees}" do
          table_for course_event.attendees do
            column :user
          end
        end
      end
    end
  end
end
