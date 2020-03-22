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

  show do |user|
    columns do
      column do
        attributes_table do
          if current_admin_user.is_root?
            row(:organization)
          end
          row(:email)
          row(:firstname)
          row(:lastname)
          row(:phone)
          row(:state)
          row(:reset_password_token)
          row(:reset_password_sent_at)
          row(:remember_created_at)
          row(:sign_in_count)
          row(:current_sign_in_at)
          row(:last_sign_in_at)
          row(:current_sign_in_ip)
          row(:last_sign_in_ip)
          row(:confirmation_token)
          row(:confirmed_at)
          row(:confirmation_sent_at)
          row(:unconfirmed_email)
          row(:created_at)
          row(:updated_at)
        end
      end
      column do
        panel link_to(Subscription.model_name.human(count: 2), admin_subscriptions_path('q[user_id_eq]' => user.id)) do
          table_for user.active_subscriptions do
            column(:active_code) { |obj| link_to obj.code, [:admin, obj] }
            column(:category)
            column(:product)
            column(:start_on)
            column(:end_on)
          end
        end
      end
    end
  end

  form do |f|
    f.inputs 'Admin' do
      f.input :organization
    end if current_admin_user.is_root?
    f.inputs do
      f.input :firstname
      f.input :lastname
      f.input :email
      f.input :phone
      f.input :password
      f.input :password_confirmation
      f.input :state
    end

    f.actions
  end

end
