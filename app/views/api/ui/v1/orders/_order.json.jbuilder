json.ignore_nil!

json.extract!(order, :id, :user_id, :state, :paid_at, :start_on, :approver_admin_user_id, :currency)
json.total_amount(order.total_amount.to_f)
json.discount(order.discount.to_f) if order.discount.to_f > 0
json.amount_to_pay(order.amount_to_pay.to_f)
json.amount_paid(order.amount_paid.to_f)

json.set!('products') do
  json.array!(order.products) do |product|
    json.partial!('api/ui/v1/products/product', product:)
  end
end

json.set!('payments') do
  json.array!(order.payments) do |payment|
    json.partial!('api/ui/v1/payments/payment', payment:)
  end
end
