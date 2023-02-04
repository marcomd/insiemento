json.ignore_nil!

json.extract!(attendee, :id, :presence)
json.user_name("#{attendee.user.firstname} #{attendee.user.lastname}")
# json.course_name attendee.course_event.course.name
