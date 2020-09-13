ActiveAdmin.register CourseEvent do
  menu parent: 'courses_management', if: proc{ can?(:read, CourseEvent) }

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :category_id, :course_id, :room_id, :trainer_id, :course_schedule_id, :event_date, :state,
                attendees_attributes: [ :id, :_destroy, :presence ]
  #
  # or

  # permit_params do
  #   permitted = [:category_id, :course_id, :room_id, :trainer_id, :course_schedule_id, :event_date, :state,
  #                attendees_attributes: [ :id, :_destroy, :presence ]
  #   ]
  #   permitted << :organization_id if current_admin_user.is_root? || params[:action] == 'create'
  #   permitted
  # end

  # before_update do |resource|
  #   if resource.attendees.where(presence: true).count > 0
  #     resource.auditor_id = current_admin_user.id # Not for admin user!
  #   end
  # end

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

  scope I18n.t('activerecord.attributes.course_event.states.active'), :active, default: true
  scope I18n.t('activerecord.attributes.course_event.states.closed'), :closed
  scope I18n.t('ui.users.commons.all')                              , :all

  index do
    selectable_column
    id_column
    column(:organization) if current_admin_user.is_root?
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
            row(:organization)
          end
          row(:category)
          row(:course)
          row(:room)
          row(:trainer)
          row(:auditor)
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
            column :id
            column :user
            column :presence
            column :created_at
            column do |obj|
              span link_to 'Mostra', [:admin, obj]
              span link_to 'Modifica', edit_admin_attendee_path(obj)
              # span link_to 'Elimina', destroy_admin_attendee_path(obj)
            end
          end
        end
      end
    end
  end

  form do |f|
    columns do
      column do
        f.inputs do
          f.semantic_errors *f.object.errors.keys
          # f.input :course_schedule, collection: f.object.course_id ? current_admin_user.course_schedules.where(course_id: f.object.course_id) : current_admin_user.course_schedules
          f.input :course_schedule, collection: current_admin_user.course_schedules
          if current_admin_user.is_root?
            f.input :organization
          else
            f.input :organization, collection: [current_admin_user.organization]
          end
          f.input :category, collection: current_admin_user.categories
          f.input :course, collection: current_admin_user.courses
          f.input :room, collection: current_admin_user.rooms
          f.input :trainer, collection: current_admin_user.trainers
          f.input :event_date, as: :date_time_picker
          f.input :state
        end
      end
      column do
        f.has_many :attendees, allow_destroy: can?(:destroy, f.object), new_record: can?(:create, f.object) do |ff|
          ff.semantic_errors *ff.object.errors.keys
          tmp_params = current_admin_user.is_root? ? nil : { 'q[organization_id_equals]' => f.object.organization_id }
          ff.input :user_id, as: :search_select, url: admin_users_path(tmp_params),
                   fields: [:firstname, :lastname], display_name: :full_name, minimum_input_length: 3,
                  order_by: 'lastname_asc'
          ff.input :presence
        end
      end
    end

    f.actions
  end
end
