json.ignore_nil!

json.extract! subscription, :id, :subscription_type, :code, :state,
              :start_on, :end_on, :max_accesses_number
json.attendees_count subscription.attendees.count unless subscription.subscription_type == 'fee'
json.category_name subscription.category.name

json.set!('product') do
  json.extract! subscription.product, :id, :name, :days
  json.price subscription.product.price.to_f
end

# It could be too big, fetch with a specific call
json.set!('attendees') do
  json.array! subscription.attendees do |attendee|
    json.extract! attendee, :id
    json.reservation_date attendee.created_at
    course_event = attendee.course_event
    if course_event
      json.set!('course_event') do
        json.extract! course_event, :id, :event_date
        json.course course_event.course.name
        json.trainer "#{course_event.trainer.firstname} #{course_event.trainer.lastname}"
        json.room course_event.room.name
      end
    end
  end
end
