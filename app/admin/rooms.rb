ActiveAdmin.register Room do
  menu parent: 'gym_management', if: proc{ can?(:read, Room) }

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :course_id, :name, :max_attendees
  #
  # or

  permit_params do
    permitted = [:name, :max_attendees, :state]
    permitted << :organization_id if current_admin_user.is_root? || params[:action] == 'create'
    permitted
  end

  controller do
    def scoped_collection
      myscope = super
      myscope = myscope.includes :organization
      myscope
    end
  end

  index do
    selectable_column
    id_column
    if current_admin_user.is_root?
      column(:organization)
    end
    column(:name)
    column(:max_attendees)
    column(:state) {|obj| span obj.localized_state, class: "status_tag #{obj.state}" }
    column(:created_at)
    column(:updated_at)
    actions
  end

  filter :organization, if: proc { current_admin_user.is_root? }
  filter :name
  filter :max_attendees
  filter :state       , as: :select, collection: Room.localized_states
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs do
      f.semantic_errors *f.object.errors.keys
      if current_admin_user.is_root?
        f.input :organization
      else
        f.input :organization, collection: [current_admin_user.organization]
      end
      f.input :name
      f.input :max_attendees
      f.input :state
    end
    f.actions
  end
end
