json.extract! user, :id,
              :email, :firstname, :lastname,
              :birthdate, :gender, :phone,
              :created_at, :updated_at

pending_order = user.pending_order
json.set!('pending_order') do
  json.partial! 'api/ui/v1/orders/order', order: pending_order
end if pending_order