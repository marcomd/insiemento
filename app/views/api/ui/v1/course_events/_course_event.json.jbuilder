json.ignore_nil!

json.extract! course_event, :id, :course, :room, :trainer, :course_schedule_id,
              :event_date, :state, :attendees_count

json.subscribed @current_user.course_event_ids.include?(course_event.id) if show_subscribed

# json.set!('users') do
#   json.array! course_event.users do |user|
#     json.partial! 'api/ui/v1/users/user', user: user
#   end if course_event.users.present?
# end
