json.extract! user, :id,
              :email, :firstname, :lastname,
              :birthdate, :gender, :phone,
              :created_at, :updated_at

# json.set!('last_subscriptions') do
#   json.array!(user.subscriptions.last(5)) do |subscription|
#     json.partial! 'api/ui/v1/subscriptions/subscription', subscription: subscription
#   end
# end

# The frontend downloads all the courses and to avoid redundant data I preferred not to include the list of
# subscribed courses also in the profile
# json.set!('course_events') do
#   json.array!(user.course_events) do |course_event|
#     json.partial! 'api/ui/v1/course_events/course_event', course_event: course_event, show_subscribed: false
#   end
# end

pending_order = user.pending_order
json.set!('pending_order') do
  json.partial! 'api/ui/v1/orders/order', order: pending_order
end if pending_order