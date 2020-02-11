ActiveAdmin.register CourseEvent do

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :course_id, :room_id, :trainer_id, :course_schedule_id, :event_date
  #
  # or

  permit_params do
    permitted = [:course_id, :room_id, :trainer_id, :course_schedule_id, :event_date, :state]
    # permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end

  controller do
    def scoped_collection
      myscope = super
      myscope = myscope.includes :course, :room, :trainer, :course_schedule
      myscope
    end

    def show
      @course_event = CourseEvent.includes(attendees: :user).find(params[:id])
    end
  end

  index do
    selectable_column
    id_column
    column(:course)
    column(:room)
    column(:trainer)
    column(:course_schedule)
    column(:event_date)
    column(:state) {|obj| span obj.state, class: "status_tag #{obj.state}" }
    actions
  end

  show do |course_event|
    columns do
      column do
        attributes_table do
          row(:course)
          row(:room)
          row(:trainer)
          row(:course_schedule)
          row(:event_date)
          row(:state) {|obj| span obj.state, class: "status_tag #{obj.state}" }
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
