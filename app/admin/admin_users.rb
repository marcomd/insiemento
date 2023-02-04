ActiveAdmin.register(AdminUser) do
  menu parent: 'platform_management', if: proc { can?(:update, AdminUser) }

  # permit_params :email, :password, :password_confirmation
  permit_params do
    permitted = %i[email firstname lastname password password_confirmation]
    permitted.concat([:organization_id, :roles_mask, { roles: [] }]) if current_admin_user.is_root?
    permitted
  end

  controller do
    def scoped_collection
      myscope = super
      myscope.includes(:organization)
    end

    def update
      unless params[:admin_user][:password].present?
        params[:admin_user].delete('password')
        params[:admin_user].delete('password_confirmation')
      end
      super
    end
  end

  index do
    selectable_column
    id_column
    column :organization
    column :firstname
    column :lastname
    column :email
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  show do |_admin_user|
    attributes_table do
      row(:organization)
      row(:email)
      row(:firstname)
      row(:lastname)
      row(:roles_mask) { |obj| obj.roles.join(', ') }
      row(:sign_in_count)
      row(:current_sign_in_at)
      row(:last_sign_in_at)
      row(:current_sign_in_ip)
      row(:last_sign_in_ip)
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
    if current_admin_user.is_root?
      f.inputs('Admin') do
        f.input(:organization)
        f.input(:roles, as: :check_boxes, collection: AdminUser::ROLES)
      end
    end
    f.inputs do
      f.input(:firstname)
      f.input(:lastname)
      f.input(:email)
      f.input(:password)
      f.input(:password_confirmation)
    end
    f.actions
  end
end
