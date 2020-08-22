ActiveAdmin.register Product do
  menu parent: 'products_management', if: proc{ can?(:read, Product) }

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :organization_id, :name, :description, :price, :days, :category_id
  #
  # or
  #
  permit_params do
    permitted = [:category_id, :product_type, :name, :description, :price, :days, :max_accesses_number, :state]
    permitted << :organization_id if current_admin_user.is_root? || params[:action] == 'create'
    permitted
  end

  controller do
    def scoped_collection
      myscope = super
      myscope = myscope.includes :organization, :category
      myscope
    end
  end

  index do
    selectable_column
    id_column
    column(:organization) if current_admin_user.is_root?
    column(:category)
    column(:product_type) { |obj| value = obj.product_type.downcase; span I18n.t("activerecord.attributes.product.product_types.#{value}"), class: "status_tag #{value}" }
    column(:name)
    column(:state) { |obj| span I18n.t("activerecord.attributes.product.states.#{obj.state}"), class: "status_tag #{obj.state}"}
    column(:price)
    column(:days)
    column(:max_accesses_number)
    column(:created_at)
    column(:updated_at)
    actions
  end

  show do |product|
    columns do
      column do
        attributes_table do
          row(:product_type) { |obj| value = obj.product_type.downcase; span I18n.t("activerecord.attributes.product.product_types.#{value}"), class: "status_tag #{value}" }
          row(:name)
          row(:description)
          row(:price)
          row(:days)
          row(:max_accesses_number)
          row(:created_at)
          row(:updated_at)
        end
      end
      column do
        panel link_to(Subscription.model_name.human(count: 2), admin_subscriptions_path('q[product_id_eq]' => product.id)) do
          table_for product.active_subscriptions.last(10) do
            column(:id)            {|obj| link_to(obj.id, admin_subscription_path(obj.id)) }
            column(:user)
            column(:subscription_type) { |obj| value = obj.subscription_type.downcase; span I18n.t("activerecord.attributes.subscription.subscription_types.#{value}"), class: "status_tag #{value}" }
            column(:state)         {|obj| span I18n.t("activerecord.attributes.subscription.states.#{obj.state}"), class: "status_tag #{obj.state}"}
            column(:start_on)
            column(:end_on)
            column(:max_accesses_number)
          end
        end
      end
    end
    active_admin_comments
  end

  filter :organization    , if: proc { current_admin_user.is_root? }
  filter :category        , collection: proc { current_admin_user.categories }
  filter :name
  filter :description
  filter :price, as: :numeric
  filter :days
  filter :state       , as: :select, collection: Product.localized_states
  filter :max_accesses_number
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
      f.input :product_type
      f.input :category, collection: current_admin_user.categories
      f.input :name
      f.input :description
      f.input :price
      f.input :days
      f.input :max_accesses_number
    end
    f.actions
  end
end
