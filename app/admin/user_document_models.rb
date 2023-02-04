ActiveAdmin.register(UserDocumentModel) do
  menu parent: 'platform_management', if: proc { can?(:read, UserDocumentModel) }

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :organization_id, :state, :title, :body, :validity_days, :recurring
  #
  # or
  #
  permit_params do
    permitted = %i[state title body validity_days recurring]
    # permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted << :organization_id if current_admin_user.is_root? || params[:action] == 'create'
    permitted
  end

  controller do
    def scoped_collection
      myscope = super
      myscope.includes(:organization)
    end
  end

  scope I18n.t('activerecord.attributes.user_document_model.states.active'), :active_state
  scope I18n.t('activerecord.attributes.user_document_model.states.suspended'), :suspended_state
  scope I18n.t('ui.users.commons.all'), :all, default: true

  index do
    selectable_column
    id_column
    column(:organization) if current_admin_user.is_root?
    column(:state) { |obj| status_tag_for obj }
    column(:title)
    column(:validity_days)
    column(:recurring)
    column(:created_at)
    column(:updated_at)
    actions
  end

  show do |user_document_model|
    columns do
      column do
        attributes_table do
          row(:organization) if current_admin_user.is_root?
          row(:state) { |obj| status_tag_for obj }
          row(:validity_days)
          row(:recurring)
          row(:created_at)
          row(:updated_at)
        end
        panel link_to(UserDocument.model_name.human(count: 2), admin_user_documents_path('q[user_document_model_id_eq]' => user_document_model.id)) do
          table_for user_document_model.user_documents.order('id desc').last(10) do
            column(:id) { |obj| link_to obj.id, [:admin, obj] }
            column(:user)
            column(:state) { |obj| status_tag_for obj }
            column(:created_at)
          end
        end
      end
      column do
        attributes_table_for user_document_model do
          row(:title)
          row(:body) do |obj|
            content_tag :pre, obj.body
          end
        end
      end
    end
    active_admin_comments
  end
end
