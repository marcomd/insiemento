ActiveAdmin.register Penalty do
  menu parent: 'users_management', if: proc { can?(:read, Penalty) }
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :organization_id, :category_id, :course_id, :state, :days
  #
  # or
  #
  permit_params do
    permitted = %i[category_id course_id state days]
    permitted << :organization_id if current_admin_user.is_root? || params[:action] == 'create'
    permitted
  end

  controller do
    def scoped_collection
      myscope = super
      myscope = myscope.includes :organization, :category, :course
      myscope
    end
  end

  index do
    selectable_column
    id_column
    column(:organization) if current_admin_user.is_root?
    column(:category)
    column(:course)
    column(:state) { |obj| status_tag_for obj }
    column(:days)
    column(:created_at)
    column(:updated_at)
    actions
  end

  filter :organization, if: proc { current_admin_user.is_root? }
  filter :category, collection: proc { current_admin_user.categories }
  filter :course, collection: proc { current_admin_user.courses }
  filter :state, as: :select, collection: Penalty.localized_states
  filter :created_at
  filter :updated_at
end
