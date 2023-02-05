ActiveAdmin.register(Category) do
  menu parent: 'products_management', if: proc { can?(:read, Category) }

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :organization_id, :name
  #
  # or
  #
  permit_params do
    permitted = [:name]
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
    column(:name)
    column(:created_at)
    column(:updated_at)
    actions
  end

  filter :organization, if: proc { current_admin_user.is_root? }
  filter :name
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
      f.input(:name)
    end
    f.actions
  end
end
