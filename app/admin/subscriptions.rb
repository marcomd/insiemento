ActiveAdmin.register Subscription do
  menu parent: 'users_management', if: proc{ can?(:read, Subscription) }

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :uuid, :organization_id, :category_id, :product_id, :user_id, :start_on, :end_on
  #
  # or
  #
  permit_params do
    permitted = [:code, :category_id, :product_id, :user_id, :start_on, :end_on, :subscription_type, :max_accesses_number]
    permitted.concat [:organization_id, :state] if current_admin_user.is_root? || params[:action] == 'create'
    permitted
  end

  controller do
    def scoped_collection
      myscope = super
      myscope = myscope.includes :organization, :category, :product
      myscope
    end
  end

  index do
    selectable_column
    id_column
    column(:organization) if current_admin_user.is_root?
    column(:category)
    column(:product)
    column(:user)
    #column(:order)
    column(:subscription_type)  { |obj| value = obj.subscription_type.downcase; span I18n.t("activerecord.attributes.subscription.subscription_types.#{value}"), class: "status_tag #{value}" }
    column(:state)              { |obj| span I18n.t("activerecord.attributes.subscription.states.#{obj.state}"), class: "status_tag #{obj.state}"}
    column(:start_on)
    column(:end_on)
    column(:max_accesses_number)
    actions
  end

  show do |subscription|
    columns do
      column do
        attributes_table do
          row(:organization) if current_admin_user.is_root?
          row(:category)
          row(:product)
          row(:user)
          #row(:order)
          row(:subscription_type) { |obj| value = obj.subscription_type.downcase; span I18n.t("activerecord.attributes.subscription.subscription_types.#{value}"), class: "status_tag #{value}" }
          row(:state)             {|obj| span I18n.t("activerecord.attributes.subscription.states.#{obj.state}"), class: "status_tag #{obj.state}"}
          row(:start_on)
          row(:end_on)
          row(:max_accesses_number)
          row(:created_at)
          row(:updated_at)
        end
      end
      column do
        panel I18n.t('activerecord.attributes.subscription.attendees') do
          table_for subscription.attendees do
            column(:course_event)
            column(:created_at)
          end
        end
      end
    end
    active_admin_comments
  end

  form do |f|
    f.inputs do
      if current_admin_user.is_root?
        f.input :organization
      else
        f.input :organization, collection: [current_admin_user.organization]
      end
      f.input :category, collection: current_admin_user.categories
      f.input :product, as: :select, collection: current_admin_user.products
      # f.input :subscription_type
      # Root admin could access all users so ability is not sufficient
      tmp_params = current_admin_user.is_root? ? nil : { 'q[organization_id_equals]' => f.object.organization_id }
      f.input :user_id, as: :search_select, url: admin_users_path(tmp_params),
              fields: [:email], display_name: 'email', minimum_input_length: 3,
              order_by: 'email_asc'

      f.input :start_on
      if current_admin_user.is_root? && params[:action] != 'create'
        f.input(:end_on)
        f.input(:code)
        f.input(:state)
      end
      f.input :max_accesses_number
    end
    f.actions
  end
end
