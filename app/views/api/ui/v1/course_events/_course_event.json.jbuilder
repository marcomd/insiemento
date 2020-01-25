json.extract! course_event, :id, :course, :room, :trainer, :course_schedule_id,
              :event_date, :state, :attendees_count

json.subscribed course_event.attendee_ids.include?(@current_user.id)

# json.set!('users') do
#   json.array! course_event.users do |user|
#     json.partial! 'api/ui/v1/users/user', user: user
#   end if course_event.users.present?
# end
