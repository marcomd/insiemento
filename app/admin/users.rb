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
    permitted = [:firstname, :lastname, :email, :birthdate, :password, :password_confirmation, :gender, :phone, :state,
                  :medical_certificate, :medical_certificate_expire_at]
    permitted << :organization_id if current_admin_user.is_root? || params[:action] == 'create'
    permitted
  end

  controller do
    def scoped_collection
      myscope = super
      myscope = myscope.includes :organization
      myscope
    end

    def update
      unless params[:user][:password].present?
        params[:user].delete 'password'
        params[:user].delete 'password_confirmation'
      end
      super
    end
  end

  index do
    selectable_column
    id_column
    if current_admin_user.is_root?
      column(:organization)
    end
    column(:firstname)
    column(:lastname)
    column(:email)
    column(:phone)
    column(:state)                 {|obj| span obj.localized_state, class: "status_tag #{obj.state}" }
    column(:current_sign_in_at)
    column(:sign_in_count)
    column(:created_at)
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
  filter :medical_certificate_expire_at
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
          row(:state)                 {|obj| span obj.localized_state, class: "status_tag #{obj.state}" }
          if user.medical_certificate.present?
            if /^image/ === user.medical_certificate.content_type
              as_image_row(:medical_certificate)
            else
              row(:medical_certificate) { |obj| link_to('Download', obj.medical_certificate) }
            end
          else
            row(:medical_certificate) { |obj| image_tag('false.png') }
          end
          row(:medical_certificate_expire_at)
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
        panel link_to(Order.model_name.human(count: 2), admin_orders_path('q[user_id_eq]' => user.id)) do
          table_for user.orders.order('id desc').limit(2) do |order|
            column(:id) { |obj| link_to obj.id, [:admin, obj] }
            column(:state)                {|obj| span obj.localized_state, class: "status_tag #{obj.state}" }
            column(:total_amount)
            column(:amount_to_pay)
            column(:amount_paid)
            column(:discount)
            column(:paid_at)
            column(:created_at)
            column(:updated_at)
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
      f.input :medical_certificate, as: :file, hint:  if f.object.medical_certificate.present?
                                                        if /^image/ === f.object.medical_certificate.content_type
                                                          image_tag(f.object.medical_certificate, height: '50px')
                                                        else
                                                          "#{f.object.medical_certificate.filename} #{number_to_human_size(f.object.medical_certificate.byte_size)}"
                                                        end
                                                      else
                                                        ''
                                                      end
      f.input :medical_certificate_expire_at #, as: :date_picker
      f.input :password
      f.input :password_confirmation
      f.input :state
    end

    f.actions
  end

end
