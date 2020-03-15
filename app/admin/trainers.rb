ActiveAdmin.register Trainer do
  menu parent: 'gym_management', if: proc{ can?(:read, Trainer) }
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :firstname, :lastname, :nickname, :bio
  #
  # or

  permit_params do
    permitted = [:firstname, :lastname, :nickname, :bio, :state]
    permitted << :organization_id if current_admin_user.is_root?
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
    column(:firstname)
    column(:lastname)
    column(:nickname)
    column(:bio)
    column(:state) {|obj| span obj.state, class: "status_tag #{obj.state}" }
    column(:created_at)
    column(:updated_at)
    actions
  end

  filter :organization    , if: proc { current_admin_user.is_root? }
  filter :firstname
  filter :lastname
  filter :nickname
  filter :bio
  filter :state       , as: :select, collection: Trainer.localized_states
  filter :created_at
  filter :updated_at
end
