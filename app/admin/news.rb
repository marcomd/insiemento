ActiveAdmin.register News do
  menu parent: 'platform_management', if: proc{ can?(:read, UserDocumentModel) }

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :organization_id, :state, :title, :body, :expire_on
  #
  # or
  #
  permit_params do
    permitted = [:title, :body, :state, :expire_on, :news_type, :dark_style, :public, :private]
    # permitted << :other if params[:action] == 'create' && current_user.admin?
    permitted << :organization_id if current_admin_user.is_root? || params[:action] == 'create'
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
    column(:organization) if current_admin_user.is_root?
    column(:title)
    column(:body)
    column(:state) {|obj| status_tag_for obj }
    column(:expire_on)
    column(:news_type) {|obj| span obj.news_type, class: "status_tag #{obj.news_type}" }
    column(:dark_style)
    column(:public)
    column(:private)
    column(:created_at)
    column(:updated_at)
    actions
  end

  filter :organization, if: proc { current_admin_user.is_root? }
  filter :title
  filter :body
  filter :state, as: :select, collection: News.localized_states
  filter :expire_on
  filter :news_type, as: :select, collection: News.news_types
  filter :dark_style
  filter :public
  filter :private
  filter :created_at
  filter :updated_at

  form do |f|
    f.inputs do
      f.semantic_errors *f.object.errors.keys
      if current_admin_user.is_root?
        f.input :organization
      else
        f.input :organization, collection: [current_admin_user.organization]
      end
      f.input :state
      f.input :news_type #, as: :select, collection: News.news_types
      f.input :title, input_html: { maxlength: 100 }
      f.input :body, as: :text, input_html: { maxlength: 255, rows: 3 }
      f.input :expire_on
      f.input :dark_style
      f.input :public
      f.input :private
    end
    f.actions
  end
end
