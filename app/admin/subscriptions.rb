ActiveAdmin.register Subscription do
  menu parent: 'users_management', if: proc{ can?(:read, Subscription) }

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :uuid, :organization_id, :category_id, :product_id, :user_id, :start_on, :end_on
  #
  # or
  #
  permit_params do
    permitted = [:uuid, :organization_id, :category_id, :product_id, :user_id, :start_on, :end_on]
    permitted << :organization_id if current_admin_user.is_root? || params[:action] == 'create'
    permitted
  end

  controller do
    def scoped_collection
      myscope = super
      myscope = myscope.includes :organization, :category, :product
      myscope
    end
  end

  form do |f|
    f.inputs do
      if current_admin_user.is_root?
        f.input :organization
      end
      f.input :category, collection: current_admin_user.categories
      f.input :product, as: :select, collection: current_admin_user.products
      # Root admin could access all users so ability is not sufficient
      tmp_params = current_admin_user.is_root? ? nil : { 'q[organization_id_equals]' => f.object.organization_id }
      f.input :user_id, as: :search_select, url: admin_users_path(tmp_params),
              fields: [:email], display_name: 'email', minimum_input_length: 3,
              order_by: 'email_asc'
      f.input :code
      f.input :start_on
      f.input :end_on
    end
    f.actions
  end
end
