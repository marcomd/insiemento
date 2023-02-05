ActiveAdmin.register(User) do
  menu parent: 'users_management', if: proc { can?(:read, User) }

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :firstname, :lastname, :email, :birthdate, :gender
  #
  # or

  permit_params do
    permitted = %i[firstname lastname email birthdate password password_confirmation gender phone state
                   medical_certificate medical_certificate_expire_at confirmed_at trainer_id
                   child_firstname child_lastname child_birthdate]
    permitted << :organization_id if current_admin_user.is_root? || params[:action] == 'create'
    permitted
  end

  controller do
    def scoped_collection
      myscope = super
      myscope.includes(:organization)
    end

    def update
      if params[:user][:password].blank?
        params[:user].delete('password')
        params[:user].delete('password_confirmation')
      end
      super
    end
  end

  scope I18n.t('activerecord.attributes.user.states.new'), :new_state
  scope I18n.t('activerecord.attributes.user.states.active'), :active_state
  scope I18n.t('activerecord.attributes.user.states.suspended'), :suspended_state
  scope I18n.t('ui.users.commons.all'), :all, default: true

  index do
    selectable_column
    id_column
    column(:organization) if current_admin_user.is_root?
    column(:firstname)
    column(:lastname)
    column(:child_firstname)
    column(:email)
    column(:phone)
    column(:state) { |obj| status_tag_for obj }
    column(:confirmed_at)
    column(:current_sign_in_at)
    column(:sign_in_count)
    column(:created_at)
    actions
  end

  filter :organization, if: proc { current_admin_user.is_root? }
  filter :state, as: :select, collection: User.localized_states
  filter :firstname
  filter :lastname
  filter :email
  filter :phone
  filter :birthdate
  filter :gender
  filter :sign_in_count
  filter :medical_certificate_expire_at
  filter :child_firstname
  filter :child_lastname
  filter :child_birthdate
  filter :confirmed_at
  filter :created_at
  filter :updated_at

  show do |user|
    script do
      raw "
      $(document).ready(function($) {
        $('#impersonate-user').on('click', function(e) {
          e.preventDefault()
          localStorage.setItem('authToken', $(e.currentTarget).data('token'))
          const win = window.open($(e.currentTarget).data('url'), '_blank')
          win.focus()
        });
      })
      "
    end
    columns do
      column do
        attributes_table do
          row(:organization) if current_admin_user.is_root?
          row(:trainer) if user.trainer_id
          row(:email)
          row(:impersonate) do |obj|
            auth_token = JsonWebToken.encode({ user_id: obj.id }, expiration_hours: 1)
            link_to(obj.full_name, '#', target: '_blank',
                                        data: {
                                          token: auth_token,
                                          url: [users_path, 'profile'].join('/'),
                                        },
                                        id: 'impersonate-user',
                                        title: "Impersona #{obj.firstname} #{obj.lastname}", rel: 'noopener')
          end
          row(:firstname)
          row(:lastname)
          row(:gender)
          row(:birthdate)
          row(:phone)
          row(:child_firstname)
          row(:child_lastname)
          row(:child_birthdate)
          row(:state) { |obj| status_tag_for obj }
          if user.medical_certificate.present?
            if /^image/ === user.medical_certificate.content_type
              as_image_row(:medical_certificate)
            else
              row(:medical_certificate) { |obj| link_to('Download', obj.medical_certificate) }
            end
          else
            row(:medical_certificate) { |_obj| image_tag('false.png') }
          end
          row(:medical_certificate_expire_at) do |obj|
            if obj.medical_certificate_expire_at
              css_class = obj.medical_certificate_expire_at < Time.zone.today ? 'red' : ''
              span(I18n.l(obj.medical_certificate_expire_at, format: :long), class: css_class)
            end
          end
          row(:sign_in_count)
          if current_admin_user.is_root?
            row(:reset_password_token)
            row(:reset_password_sent_at)
            row(:remember_created_at)
            row(:current_sign_in_at)
            row(:last_sign_in_at)
            row(:current_sign_in_ip)
            row(:last_sign_in_ip)
            row(:confirmation_token)
            row(:confirmed_at)
            row(:confirmation_sent_at)
            row(:unconfirmed_email)
          else
            row(:confirmed_at)
          end
          row(:created_at)
          row(:updated_at)
        end
      end
      column do
        panel link_to(Subscription.model_name.human(count: 2), admin_subscriptions_path('q[user_id_eq]' => user.id)) do
          table_for user.subscriptions.not_ended do
            column(:active_code) { |obj| link_to obj.code, [:admin, obj] }
            column(:category)
            column(:product)
            column(:start_on)
            column(:end_on)
          end
        end
        panel link_to(Order.model_name.human(count: 2), admin_orders_path('q[user_id_eq]' => user.id)) do
          table_for user.orders.order('id desc').limit(2) do |_order|
            column(:id) { |obj| link_to obj.id, [:admin, obj] }
            column(:state) { |obj| status_tag_for obj }
            column(:total_amount)
            column(:amount_to_pay)
            column(:amount_paid)
            column(:discount)
            column(:paid_at)
            column(:created_at)
            column(:updated_at)
          end
        end
        panel link_to(UserDocument.model_name.human(count: 2), admin_user_documents_path('q[user_id_eq]' => user.id)) do
          table_for user.user_documents.order('id desc').limit(2) do |_user_document|
            column(:id) { |obj| link_to obj.id, [:admin, obj] }
            column(:user_document_model) { |obj| link_to obj.user_document_model.title, [:admin, obj.user_document_model] }
            column(:state) { |obj| status_tag_for obj }
            column(:created_at)
          end
        end
      end
    end
  end

  form do |f|
    columns do
      column do
        f.inputs do
          if current_admin_user.is_root?
            f.input(:organization)
          else
            f.input(:organization, collection: [current_admin_user.organization])
          end
          f.input(:firstname)
          f.input(:lastname)
          f.input(:email)
          f.input(:phone)
          f.input(:birthdate, as: :date_picker)
          f.input(:gender, as: :select, collection: [%w[Maschio M], %w[Femmina F], %w[Robot R]])
          f.input(:medical_certificate, as: :file, hint:  if f.object.medical_certificate.present?
                                                            if /^image/ === f.object.medical_certificate.content_type
                                                              image_tag(f.object.medical_certificate, height: '50px')
                                                            else
                                                              "#{f.object.medical_certificate.filename} #{number_to_human_size(f.object.medical_certificate.byte_size)}"
                                                            end
                                                          else
                                                            ''
                                                          end)
          f.input(:medical_certificate_expire_at, as: :date_picker)
          f.input(:password)
          f.input(:password_confirmation)
          f.input(:state)
          f.input(:confirmed_at, as: :datetime_picker)
          tmp_params = current_admin_user.is_root? ? nil : { 'q[organization_id_equals]' => f.object.organization_id }
          f.input(:trainer_id, as: :search_select, url: admin_trainers_path(tmp_params),
                               fields: [:lastname], display_name: 'lastname', minimum_input_length: 3,
                               order_by: 'lastname_asc')
        end
      end

      column do
        f.inputs('Bambino') do
          f.input(:child_firstname)
          f.input(:child_lastname)
          f.input(:child_birthdate, as: :date_picker)
        end
      end
    end

    f.actions
  end
end
