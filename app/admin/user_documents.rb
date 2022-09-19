ActiveAdmin.register UserDocument do
  menu parent: 'users_management', if: proc { can?(:read, UserDocument) }

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :organization_id, :user_document_model_id, :user_id, :state, :title, :body, :expire_on, :sign_checksum
  #
  # or
  #
  # permit_params do
  #   permitted = [:organization_id, :document_id, :user_id, :state]
  #   permitted << :other if params[:action] == 'create' && current_user.admin?
  #   permitted
  # end

  # Allow format for pdf generation
  skip_before_action :restrict_format_access!, only: [:show]

  controller do
    include AdminSharedBatchActions

    def scoped_collection
      myscope = super
      myscope = myscope.includes :organization, :user_document_model, :user
      myscope
    end

    def show
      @user_document = UserDocument.find(params[:id])

      respond_to do |format|
        format.html
        format.pdf do
          pdf = Prawn::Document.new
          pdf.text @user_document.parsed_body
          send_data pdf.render, type: 'application/pdf', disposition: 'inline'
        end
      end
    end
  end

  scope I18n.t('activerecord.attributes.user_document.states.draft'), :draft
  scope I18n.t('activerecord.attributes.user_document.states.ready'), :ready
  scope I18n.t('activerecord.attributes.user_document.states.exporting'), :exporting
  scope I18n.t('activerecord.attributes.user_document.states.exporting_error'), :exporting_error
  scope I18n.t('activerecord.attributes.user_document.states.exported'), :exported
  scope I18n.t('activerecord.attributes.user_document.states.signed'), :signed
  scope I18n.t('activerecord.attributes.user_document.states.completed'), :completed
  scope I18n.t('ui.users.commons.all'), :all, default: true

  index do
    selectable_column
    id_column
    column(:organization) if current_admin_user.is_root?
    column(:user_document_model)
    column(:user)
    column(:state) { |obj| status_tag_for obj }
    column(:title)
    column(:expire_on)
    column(:created_at)
    column(:updated_at)
    actions
  end

  batch_action :invia, if: proc { @current_scope && %i[draft exporting_error].include?(@current_scope.scope_method) },
                       confirm: 'Confermi di voler inviare a Otp Service le pratiche selezionate?' do |selection|
    shared_batch_action class_object: UserDocument, selection: selection,
                        action_name: 'send_to_otpservice', is_transaction: true,
                        return_scope_if_ok: I18n.t('activerecord.attributes.user_document.states.ready').downcase,
                        return_scope_if_error: I18n.t('activerecord.attributes.user_document.states.draft').downcase
  end
  batch_action :annulla_invio, if: proc { @current_scope && @current_scope.scope_method == :ready && current_admin_user.is_root? },
                               confirm: 'Confermi di voler annullare l''invio delle pratiche selezionate?' do |selection|
    shared_batch_action class_object: UserDocument, selection: selection,
                        action_name: 'not_ready_anymore', is_transaction: true,
                        return_scope_if_ok: I18n.t('activerecord.attributes.user_document.states.draft').downcase,
                        return_scope_if_error: I18n.t('activerecord.attributes.user_document.states.ready').downcase
  end

  filter :organization, if: proc { current_admin_user.is_root? }
  filter :user_document_model, collection: proc { current_admin_user.user_document_models }
  filter :user, collection: proc { current_admin_user.users }
  filter :state, as: :select, collection: UserDocument.localized_states
  filter :title
  filter :body
  filter :expire_on
  filter :sign_checksum
  filter :created_at
  filter :updated_at

  show do |user_document|
    columns do
      column do
        attributes_table do
          row(:organization) if current_admin_user.is_root?
          row(:uuid)
          row(:user_document_model)
          row(:user)
          row(:state) { |obj| status_tag_for obj }
          row(:sign_checksum) do |obj|
            if obj.sign_checksum
              link_to(obj.sign_checksum, "#{CONFIG.dig(:otpservice, :host)}/users/signature?checksum=#{obj.sign_checksum}", target: '_blank')
            end
          end
          row(:expire_on)
          row(:created_at)
          row(:updated_at)
        end
      end
      column do
        attributes_table_for user_document do
          row(:title)
          row(:body) do |obj|
            content_tag :pre, obj.parsed_body
          end
        end
      end
    end
    active_admin_comments
  end

  form do |f|
    columns do
      column do
        if current_admin_user.is_root?
          f.inputs 'Admin' do
            f.input :organization
            f.input :uuid
            f.input :sign_checksum
          end
        end
        f.inputs do
          f.semantic_errors(*f.object.errors.keys)
          f.input(:organization, collection: [current_admin_user.organization]) unless current_admin_user.is_root?
          tmp_params = current_admin_user.is_root? ? nil : { 'q[organization_id_equals]' => f.object.organization_id }
          f.input :user_id, as: :search_select, url: admin_users_path(tmp_params),
                            fields: %i[firstname lastname], display_name: :full_name, minimum_input_length: 3,
                            order_by: 'lastname_asc'
          f.input :user_document_model
          f.input :state
          f.input :expire_on
        end
      end
      column do
        f.inputs do
          f.input :title
          f.input :body, input_html: { rows: 30, class: 'autogrow' }
        end
      end
    end

    f.actions
  end

  action_item :pdf, only: %i[show edit] do
    if authorized?(:pdf, user_document)
      link_to 'Pdf', admin_user_document_path(user_document, format: :pdf), target: '_blank'
    end
  end
end
