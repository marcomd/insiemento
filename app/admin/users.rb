ActiveAdmin.register User do
  menu parent: 'users_management', if: proc{ can?(:read, User) }

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :firstname, :lastname, :email, :birthdate, :gender
  #
  # or

  permit_params do
    permitted = [:firstname, :lastname, :email, :birthdate, :password, :password_confirmation, :gender, :phone, :state]
    # permitted << :other if params[:action] == 'create' && current_user.admin?
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
    column :firstname
    column :lastname
    column :email
    column :phone
    column :current_sign_in_at
    column :sign_in_count
    column :created_at
    actions
  end

  filter :organization, if: proc { current_admin_user.is_root? }
  filter :state       , as: :select, collection: User.localized_states
  filter :firstname
  filter :lastname
  filter :email
  filter :phone
  filter :birthdate
  filter :gender
  filter :sign_in_count
  filter :created_at
  filter :updated_at

end
