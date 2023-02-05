ActiveAdmin.register(CourseSchedule) do
  menu parent: 'courses_management', if: proc { can?(:read, CourseSchedule) }

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :course_id, :room_id, :trainer_id, :event_day, :event_time
  #
  # or

  permit_params do
    permitted = %i[category_id course_id room_id trainer_id event_day event_time state]
    # permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted << :organization_id if current_admin_user.is_root? || params[:action] == 'create'
    permitted
  end

  controller do
    include AdminSharedBatchActions

    def scoped_collection
      myscope = super
      myscope.includes(:organization, :category, :course, :room, :trainer)
    end
  end

  scope I18n.t('activerecord.attributes.course_schedule.states.active'), :active, default: true
  scope I18n.t('activerecord.attributes.course_schedule.states.suspended'), :suspended
  scope I18n.t('ui.users.commons.all'), :all

  index do
    selectable_column
    id_column
    column(:organization) if current_admin_user.is_root?
    column(:category)
    column(:course)
    column(:room)
    column(:trainer)
    column(:event_day, &:localized_event_day)
    column(:event_time, &:event_time_short)
    column(:state) { |obj| status_tag_for obj }
    column(:created_at)
    column(:updated_at)
    actions
  end

  batch_action :sospendi, if: proc { @current_scope && @current_scope.scope_method == :active },
                          confirm: 'Confermi di voler sospendere le schedulazioni selezionate?' do |selection|
    shared_batch_action class_object: CourseSchedule, selection:, action_name: 'pause', is_transaction: true, return_scope_if_ok: 'suspended', return_scope_if_error: 'active'
  end

  batch_action :attiva, if: proc { @current_scope && @current_scope.scope_method == :suspended },
                        confirm: 'Confermi di voler riattivare le schedulazioni selezionate?' do |selection|
    shared_batch_action class_object: CourseSchedule, selection:, action_name: 'activate', is_transaction: true, return_scope_if_ok: 'active', return_scope_if_error: 'suspended'
  end

  filter :organization, if: proc { current_admin_user.is_root? }
  filter :category, collection: proc { current_admin_user.categories }
  filter :course, collection: proc { current_admin_user.courses }
  filter :room, collection: proc { current_admin_user.rooms }
  filter :trainer, collection: proc { current_admin_user.trainers }
  filter :event_day, as: :select, collection: CourseSchedule.localized_event_days
  # filter :event_time
  filter :state, as: :select, collection: CourseSchedule.localized_states
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs do
      f.semantic_errors(*f.object.errors.attribute_names)
      if current_admin_user.is_root?
        f.input(:organization)
      else
        f.input(:organization, collection: [current_admin_user.organization])
      end
      f.input(:category, collection: current_admin_user.categories)
      f.input(:course, collection: current_admin_user.courses.active)
      f.input(:room, collection: current_admin_user.rooms)
      f.input(:trainer, collection: current_admin_user.trainers)
      f.input(:event_day)
      f.input(:event_time, as: :time_picker)
      f.input(:state)
    end
    f.actions
  end
end
