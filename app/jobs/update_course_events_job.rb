class UpdateCourseEventsJob < ApplicationJob
  queue_as :course_events

  def perform
    CourseEvent.where(state: %i[active suspended]).where('event_date < ?', 70.minutes.ago).update_all(state: :closed)
  end
end
