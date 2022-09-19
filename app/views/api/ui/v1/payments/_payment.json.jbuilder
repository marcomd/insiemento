json.ignore_nil!

json.extract! payment, :id, :type, :state, :confirmation_token
json.amount payment.amount.to_f
