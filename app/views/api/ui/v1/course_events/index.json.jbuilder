json.array!(@course_events) do |course_event|
  json.partial! 'api/ui/v1/course_events/course_event', course_event: course_event, show_subscribed: true
end
