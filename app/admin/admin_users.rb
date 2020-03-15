ActiveAdmin.register AdminUser do
  menu parent: 'platform_management', if: proc{ can?(:update, AdminUser) }

  # permit_params :email, :password, :password_confirmation
  permit_params do
    permitted = [:email, :password, :password_confirmation]
    permitted << :organization_id if current_admin_user.root?
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
    column :organization
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  show do |admin_user|
    attributes_table do
      row(:email)
      row(:organization)
      row(:roles_mask)  { |obj| obj.roles.join(', ') }
      row(:current_sign_in_at)
      row(:sign_in_count)
      row(:reset_password_token)
      row(:reset_password_sent_at)
      row(:remember_created_at)
      row(:created_at)
      row(:updated_at)
    end
  end

  filter :organization
  filter :email
  filter :current_sign_in_at
  filter :sign_in_count
  filter :created_at

  form do |f|
    f.inputs do
      f.input(:organization) if current_admin_user.root?
      f.input :email
      f.input :password
      f.input :password_confirmation
    end
    f.actions
  end

end
