ActiveAdmin.register Order do
  menu parent: 'payments_management', if: proc{ can?(:read, Order) }

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :organization_id, :user_id, :state, :amount_to_pay, :amount_paid, :currency, :paid_at, :approver_admin_user_id
  #
  # or
  #
  permit_params do
    permitted = [:user_id, :state, :discount,
                 :currency, :paid_at, :start_on, :approver_admin_user_id,
                 order_products_attributes: [ :id, :_destroy, :order_id, :product_id ],
    ]
    permitted = permitted.concat([:organization_id, :total_amount, :amount_to_pay, :amount_paid]) if current_admin_user.is_root? || params[:action] == 'create'
    permitted
  end

  controller do
    def scoped_collection
      myscope = super
      myscope = myscope.includes :organization, :user
      myscope
    end
    def create
      params[:order][:organization_id] = current_admin_user.organization_id unless current_admin_user.is_root?
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
    column(:state)                {|obj| span obj.localized_state, class: "status_tag #{obj.state}" }
    column(:total_amount)
    column(:amount_to_pay)
    column(:amount_paid)
    column(:discount)
    column(:paid_at)
    column(:created_at)
    column(:updated_at)
    actions
  end

  filter :organization, if: proc { current_admin_user.is_root? }
  filter :user        , collection: proc { current_admin_user.users }
  filter :state       , as: :select, collection: Order.localized_states
  filter :currency    , as: :select, collection: Order.currencies
  filter :total_amount  , as: :numeric
  filter :amount_to_pay , as: :numeric
  filter :amount_paid   , as: :numeric
  filter :discount      , as: :numeric
  filter :start_on
  filter :paid_at
  filter :created_at
  filter :updated_at

  show do |order|
    columns do
      column do
        attributes_table do
          if current_admin_user.is_root?
            row(:organization)
          end
          row(:user)
          row(:state) {|obj| span obj.localized_state, class: "status_tag #{obj.state}" }
          row(:currency)
          row(:total_amount)
          row(:discount)
          row(:amount_to_pay)
          row(:amount_paid)
          row(:paid_at)
          row(:start_on)
          row(:created_at)
          row(:updated_at)
        end
      end
      column do
        panel Product.model_name.human(count: 2) do
          table_for order.products do
            column(:id)           { |obj| link_to "#{obj.id}", [:admin, obj]}
            column(:category)
            column(:name)
            column(:price)
            column(:days)
          end
        end
        panel Payment.model_name.human(count: 2) do
          table_for order.payments do
            column(:id)           { |obj| link_to "#{obj.id}", [:admin, obj]}
            column(:user)
            column(:source)
            column(:state)        { |obj| span obj.localized_state, class: "status_tag #{obj.state}" }
            column(:amount)
          end
        end
      end
    end
  end

  # Inserire i prodotti nel form
  form do |f|
    tabs do
      tab Order.model_name.human(count: 1) do
        columns do
          column do
            f.inputs do
              if current_admin_user.is_root?
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
                        }
              else
                #tmp_params = current_admin_user.is_root? ? nil : { 'q[organization_id_equals]' => f.object.organization_id }
                f.input :user_id, as: :search_select, url: admin_users_path,
                        fields: [:email], display_name: 'email', minimum_input_length: 3,
                        order_by: 'email_asc', input_html: {class: 'after_user_selection'}
              end
              f.input :state
              f.input :start_on
            end
          end
          column do
            f.inputs do
              f.input :currency
              f.input :total_amount, input_html: {disabled: true}
              f.input :discount
              # f.input :amount_to_pay
              f.input :amount_paid, input_html: {disabled: true}
              f.input :paid_at, as: :date_time_picker
            end
          end unless f.object.new_record?
        end
      end
      tab OrderProduct.model_name.human(count: 2) do
        f.inputs do
          f.has_many :order_products, heading: nil, allow_destroy: can?(:destroy, f.object), new_record: can?(:create, f.object) do |ff|
            tmp_params = current_admin_user.is_root? ? nil : { 'q[organization_id_equals]' => f.object.organization_id }
            ff.input :product_id, as: :search_select, url: admin_products_path(tmp_params),
                     fields: [:name], display_name: 'name', minimum_input_length: 3,
                     order_by: 'name_asc'
          end
        end
      end if can?(:create, f.object)
    end


    f.actions
  end
end
