ActiveAdmin.register Subscription do
  menu parent: 'users_management', if: proc{ can?(:read, Subscription) }

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :uuid, :organization_id, :category_id, :product_id, :user_id, :start_on, :end_on
  #
  # or
  #
  # permit_params do
  #   permitted = [:uuid, :organization_id, :product_id, :user_id, :start_on, :end_on]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  controller do
    def scoped_collection
      myscope = super
      myscope = myscope.includes :organization, :category, :product
      myscope
    end
  end
end
