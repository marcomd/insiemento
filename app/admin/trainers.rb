ActiveAdmin.register(Trainer) do
  menu parent: 'gym_management', if: proc { can?(:read, Trainer) }
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :firstname, :lastname, :nickname, :bio
  #
  # or

  permit_params do
    permitted = %i[firstname lastname nickname bio state]
    permitted << :organization_id if current_admin_user.is_root? || params[:action] == 'create'
    permitted
  end

  controller do
    def scoped_collection
      myscope = super
      myscope.includes(:organization)
    end
  end

  index do
    selectable_column
    id_column
    column(:organization) if current_admin_user.is_root?
    column(:firstname)
    column(:lastname)
    column(:nickname)
    column(:state) { |obj| status_tag_for obj }
    column(:created_at)
    column(:updated_at)
    actions
  end

  filter :organization, if: proc { current_admin_user.is_root? }
  filter :firstname
  filter :lastname
  filter :nickname
  filter :bio
  filter :state, as: :select, collection: Trainer.localized_states
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
      f.input(:firstname)
      f.input(:lastname)
      f.input(:nickname)
      f.input(:bio)
      f.input(:state)
    end
    f.actions
  end
end
