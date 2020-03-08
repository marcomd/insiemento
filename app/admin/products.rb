ActiveAdmin.register Product do
  menu parent: 'products_management', if: proc{ can?(:read, Product) }

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :organization_id, :name, :description, :price_cents, :days, :category_id
  #
  # or
  #
  # permit_params do
  #   permitted = [:organization_id, :name, :description, :price_cents, :days, :category_id, :premium]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  controller do
    def scoped_collection
      myscope = super
      myscope = myscope.includes :organization, :category
      myscope
    end
  end
end
