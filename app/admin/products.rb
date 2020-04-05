ActiveAdmin.register Product do
  menu parent: 'products_management', if: proc{ can?(:read, Product) }

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :organization_id, :name, :description, :price, :days, :category_id
  #
  # or
  #
  permit_params do
    permitted = [:name, :description, :price, :days, :category_id]
    permitted << :organization_id if current_admin_user.is_root? || params[:action] == 'create'
    permitted
  end

  controller do
    def scoped_collection
      myscope = super
      myscope = myscope.includes :organization, :category
      myscope
    end
  end

  index do
    selectable_column
    id_column
    if current_admin_user.is_root?
      column(:organization)
    end
    column(:category)
    column(:name)
    column(:description)
    column(:price)
    column(:days)
    # column(:state) {|obj| span obj.state, class: "status_tag #{obj.state}" }
    column(:created_at)
    column(:updated_at)
    actions
  end

  filter :organization    , if: proc { current_admin_user.is_root? }
  filter :category        , collection: proc { current_admin_user.categories }
  filter :name
  filter :description
  filter :price, as: :numeric
  filter :days
  # filter :state       , as: :select, collection: Course.localized_states
  filter :created_at
  filter :updated_at
end
