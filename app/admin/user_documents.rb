ActiveAdmin.register UserDocument do
  menu parent: 'users_management', if: proc{ can?(:read, UserDocument) }

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  permit_params :organization_id, :user_document_model_id, :user_id, :state, :title, :body, :expire_on
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

  scope I18n.t('activerecord.attributes.user_document.states.draft')            , :draft
  scope I18n.t('activerecord.attributes.user_document.states.ready')            , :ready
  scope I18n.t('activerecord.attributes.user_document.states.exporting')        , :exporting
  scope I18n.t('activerecord.attributes.user_document.states.exporting_error')  , :exporting_error
  scope I18n.t('activerecord.attributes.user_document.states.exported')         , :exported
  scope I18n.t('activerecord.attributes.user_document.states.signed')           , :signed
  scope I18n.t('activerecord.attributes.user_document.states.completed')        , :completed
  scope I18n.t('ui.users.commons.all')                                          , :all, default: true

  index do
    selectable_column
    id_column
    column(:organization) if current_admin_user.is_root?
    column(:user_document_model)
    column(:user)
    column(:state) {|obj| span obj.localized_state, class: "status_tag #{obj.state}" }
    column(:title)
    column(:expire_on)
    column(:created_at)
    column(:updated_at)
    actions
  end

  batch_action :invia, :if => proc{ @current_scope && @current_scope.id == I18n.t('activerecord.attributes.user_document.states.draft').downcase },
               confirm: 'Confermi di voler inviare a Otp Service le pratiche selezionate?' do |selection|
    shared_batch_action class_object: UserDocument, selection: selection, transaction_name: 'send_to_otpservice',
                        return_scope_if_ok: I18n.t('activerecord.attributes.user_document.states.ready').downcase,
                        return_scope_if_error: I18n.t('activerecord.attributes.user_document.states.draft').downcase
  end
  batch_action :annulla_invio, :if => proc{ @current_scope && @current_scope.id == I18n.t('activerecord.attributes.user_document.states.ready').downcase && current_admin_user.is_root? },
               confirm: 'Confermi di voler annullare l''invio delle pratiche selezionate?' do |selection|
    shared_batch_action class_object: UserDocument, selection: selection, transaction_name: 'not_ready_anymore',
                        return_scope_if_ok: I18n.t('activerecord.attributes.user_document.states.draft').downcase,
                        return_scope_if_error: I18n.t('activerecord.attributes.user_document.states.ready').downcase
  end

  filter :organization, if: proc { current_admin_user.is_root? }
  filter :user_document_model, collection: proc { current_admin_user.user_document_models }
  filter :user        , collection: proc { current_admin_user.users }
  filter :state       , as: :select, collection: UserDocument.localized_states
  filter :title
  filter :body
  filter :expire_on
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
          row(:state) {|obj| span obj.localized_state, class: "status_tag #{obj.state}" }
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

  action_item :pdf, only: [:show, :edit] do
    if authorized?(:pdf, user_document)
      link_to 'Pdf', admin_user_document_path(user_document, format: :pdf), target: '_blank'
    end
  end
end
