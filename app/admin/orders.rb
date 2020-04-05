ActiveAdmin.register Order do
  menu parent: 'payments_management', if: proc{ can?(:read, Order) }

  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  # Uncomment all parameters which should be permitted for assignment
  #
  # permit_params :organization_id, :user_id, :state, :amount_to_pay_cents, :amount_paid_cents, :currency, :paid_at, :approver_admin_user_id
  #
  # or
  #
  permit_params do
    permitted = [:user_id, :state, :total_amount_cents, :amount_to_pay_cents, :amount_paid_cents, :discount_cents,
                 :currency, :paid_at, :start_on, :approver_admin_user_id]
    permitted << :organization_id if current_admin_user.is_root?
    permitted
  end

  controller do
    def scoped_collection
      myscope = super
      myscope = myscope.includes :organization, :user
      myscope
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
    column(:total_amount_cents)   { |obj| Money.new(obj.total_amount_cents).to_s }
    column(:amount_to_pay_cents)  { |obj| Money.new(obj.amount_to_pay_cents).to_s }
    column(:amount_paid_cents)    { |obj| Money.new(obj.amount_paid_cents).to_s }
    column(:discount_cents)       { |obj| Money.new(obj.discount_cents).to_s }
    column(:paid_at)
    column(:created_at)
    column(:updated_at)
    actions
  end

  filter :organization, if: proc { current_admin_user.is_root? }
  filter :user        , collection: proc { current_admin_user.users }
  filter :state       , as: :select, collection: Order.localized_states
  filter :currency
  filter :total_amount_cents
  filter :amount_to_pay_cents
  filter :amount_paid_cents
  filter :discount_cents
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
          row(:total_amount_cents)   { |obj| Money.new(obj.total_amount_cents).to_s }
          row(:amount_to_pay_cents)  { |obj| Money.new(obj.amount_to_pay_cents).to_s }
          row(:amount_paid_cents)    { |obj| Money.new(obj.amount_paid_cents).to_s }
          row(:discount_cents)       { |obj| Money.new(obj.discount_cents).to_s }
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
            column(:price_cents)  { |obj| Money.new(obj.price_cents).to_s }
            column(:days)
          end
        end
        panel Payment.model_name.human(count: 2) do
          table_for order.payments do
            column(:id)           { |obj| link_to "#{obj.id}", [:admin, obj]}
            column(:user)
            column(:source)
            column(:state)        { |obj| span obj.localized_state, class: "status_tag #{obj.state}" }
            column(:amount_cents) { |obj| Money.new(obj.amount_cents).to_s }
          end
        end
      end
    end
  end
end
