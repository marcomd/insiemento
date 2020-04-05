ActiveAdmin.register Payment do
  menu parent: 'payments_management', if: proc{ can?(:read, Payment) }

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :organization_id, :user_id, :order_id, :source, :state, :amount_cents
  #
  # or
  #
  permit_params do
    permitted = [:user_id, :order_id, :source, :state, :amount_cents]
    permitted << :organization_id if current_admin_user.is_root? || params[:action] == 'create'
    permitted
  end

  controller do
    def scoped_collection
      myscope = super
      myscope = myscope.includes :organization, :user, :order
      myscope
    end
    def create
      params[:payment][:organization_id] = current_admin_user.organization_id unless current_admin_user.is_root?
      super
    end
  end

  index do
    selectable_column
    id_column
    if current_admin_user.is_root?
      column(:organization)
    end
    column(:user)
    column(:order)
    column(:state)          { |obj| span obj.localized_state, class: "status_tag #{obj.state}" }
    column(:amount_cents)   { |obj| Money.new(obj.amount_cents).to_s }
    column(:created_at)
    column(:updated_at)
    actions
  end

  filter :organization, if: proc { current_admin_user.is_root? }
  filter :user        , collection: proc { current_admin_user.users }
  filter :order       , collection: proc { current_admin_user.orders }
  filter :state       , as: :select, collection: Order.localized_states
  filter :amount_cents
  filter :created_at
  filter :updated_at

  show do |order|
    attributes_table do
      if current_admin_user.is_root?
        row(:organization)
      end
      row(:user)
      row(:order)
      row(:state) {|obj| span obj.localized_state, class: "status_tag #{obj.state}" }
      row(:amount_cents)   { |obj| Money.new(obj.amount_cents).to_s }
      row(:created_at)
      row(:updated_at)
    end
  end

  form do |f|
    columns do
      column do
        if current_admin_user.is_root?
          f.inputs 'Admin' do
            f.input :organization_id, as: :nested_select,
                    minimum_input_length: 0,
                    level_1: {
                        attribute: :organization_id,
                        fields: [:name],
                        display_name: :name,
                        minimum_input_length: 3,
                        url: '\admin\organizations',
                    },
                    level_2: {
                        attribute: :user_id,
                        fields: [:email],
                        display_name: :email,
                        minimum_input_length: 3,
                        url: '\admin\users',
                    },
                    level_3: {
                        attribute: :order_id,
                        fields: [:id],
                        display_name: :start_on,
                        url: '\admin\orders',
                    }
          end
        else
          f.inputs do
            #tmp_params = current_admin_user.is_root? ? nil : { 'q[organization_id_equals]' => f.object.organization_id }
            # f.input :user_id, as: :search_select, url: admin_users_path(tmp_params),
            #         fields: [:email], display_name: 'email', minimum_input_length: 3,
            #         order_by: 'email_asc', input_html: {class: 'after_user_selection'}
            # f.input :order_id, as: :search_select, url: admin_orders_path( 'q[user_id_equals]' => f.object.user_id),
            #         fields: [:start_on], display_name: 'id', minimum_input_length: 2,
            #         order_by: 'id_asc'
            # f.input :order, as: :select, collection: (f.object.user_id ? f.object.users.active : []), input_html: {class: 'orders_target'}
            f.input :user_id, as: :nested_select,
                    minimum_input_length: 0,
                    level_1: {
                        attribute: :user_id,
                        fields: [:email],
                        display_name: :email,
                        minimum_input_length: 3,
                        url: '\admin\users',
                    },
                    level_2: {
                        attribute: :order_id,
                        fields: [:id],
                        display_name: :start_on,
                        url: '\admin\orders',
                    }
          end
        end
      end
      column do
        f.inputs do
          f.input :state
          f.input :amount_cents
        end
      end
    end

    f.actions
  end
end
