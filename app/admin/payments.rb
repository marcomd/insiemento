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
    permitted << :organization_id if current_admin_user.is_root?
    permitted
  end

  controller do
    def scoped_collection
      myscope = super
      myscope = myscope.includes :organization, :user, :order
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
end
