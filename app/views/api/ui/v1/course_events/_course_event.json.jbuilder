json.ignore_nil!

json.extract!(course_event, :id, :course_schedule_id, :event_date, :state, :attendees_count)

json.set!('trainer') do
  json.partial!('api/ui/v1/trainers/trainer', trainer: course_event.trainer)
end
json.set!('course') do
  json.partial!('api/ui/v1/courses/course', course: course_event.course)
end
json.set!('room') do
  json.partial!('api/ui/v1/rooms/room', room: course_event.room)
end

json.subscribed(@current_user.course_event_ids.include?(course_event.id)) if show_subscribed

# json.set!('users') do
#   json.array! course_event.users do |user|
#     json.partial! 'api/ui/v1/users/user', user: user
#   end if course_event.users.present?
# end
