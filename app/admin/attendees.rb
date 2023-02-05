ActiveAdmin.register(Attendee) do
  menu parent: 'courses_management', if: proc { can?(:read, Attendee) }

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :user_id, :course_event_id, :subscription_id, :presence
  #
  # or
  #
  # permit_params do
  #   permitted = [:user_id, :course_event_id, :subscription_id, :organization_id, :presence]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  controller do
    include AdminSharedBatchActions

    def scoped_collection
      myscope = super
      myscope.includes(:organization, :course_event, :user, :subscription)
    end

    def show
      @course_event = CourseEvent.includes(attendees: :user).find(params[:id])
    end
  end

  scope I18n.t('activerecord.attributes.attendee.present_at_this_time'), :present_at_this_time
  scope I18n.t('ui.users.commons.all'), :all, default: true

  index do
    selectable_column
    id_column
    column(:organization) if current_admin_user.is_root?
    column(:course_event)
    column(:user)
    column(:subscription)
    column(:presence)
    column(:event_at) { |obj| obj.course_event.event_date }
    column(:created_at)
    column(:updated_at)
    actions
  end

  batch_action :destroy, if: proc { @current_scope },
                         confirm: 'Confermi di voler eliminare i partecipanti selezionati? (li hai avvisati?)' do |selection|
    shared_batch_action class_object: Attendee, selection:, action_name: 'destroy' # , return_scope_if_ok:'all', return_scope_if_error:'all'
  end

  batch_action :elimina_senza_controlli, if: proc { @current_scope },
                                         confirm: 'Confermi di voler eliminare i partecipanti selezionati? (li hai avvisati?)' do |selection|
    records = Attendee.find(selection)
    records.each { |record| record.disable_bookability_checks = true }
    shared_batch_action class_object: Attendee, records:, action_name: 'destroy' # , return_scope_if_ok:'all', return_scope_if_error:'all'
  end

  filter :organization, if: proc { current_admin_user.is_root? }
  filter :user, collection: proc { current_admin_user.users }
  filter :course_event_id
  filter :subscription_id
  filter :presence
  filter :created_at
  filter :updated_at

  form do |f|
    columns do
      column do
        f.inputs do
          f.semantic_errors(*f.object.errors.attribute_names)
          if current_admin_user.is_root?
            f.input(:organization)
          else
            f.input(:organization, collection: [current_admin_user.organization])
          end
          tmp_params = current_admin_user.is_root? ? nil : { 'q[organization_id_equals]' => f.object.organization_id }
          f.input(:user_id, as: :search_select, url: admin_users_path(tmp_params),
                            fields: %i[firstname lastname], display_name: :full_name, minimum_input_length: 3,
                            order_by: 'lastname_asc')
          f.input(:course_event_id)
          f.input(:subscription_id)
          f.input(:presence)
        end
      end
    end

    f.actions
  end
end
