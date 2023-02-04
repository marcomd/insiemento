ActiveAdmin.register(UserPenalty) do
  menu parent: 'users_management', if: proc { can?(:read, UserPenalty) }
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :organization_id, :user_id, :subscription_id, :course_event_id, :attendee_id, :category_id, :course_id, :inhibited_until
  #
  # or
  #
  permit_params do
    permitted = %i[user_id subscription_id course_event_id attendee_id category_id course_id inhibited_until]
    permitted << :organization_id if current_admin_user.is_root? || params[:action] == 'create'
    # permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted
  end

  controller do
    def scoped_collection
      myscope = super
      myscope.includes(:organization, :user, :subscription, :course_event, :attendee, :category, :course)
    end
  end

  index do
    selectable_column
    id_column
    column(:organization) if current_admin_user.is_root?
    column(:user)
    column(:category)
    column(:course)
    column(:course_event)
    column(:attendee)
    column(:inhibited_until)
    # column(:state) { |obj| span I18n.t("activerecord.attributes.user_penalty.states.#{obj.state}"), class: "status_tag #{obj.state}"}
    column(:created_at)
    column(:updated_at)
    actions
  end
end
