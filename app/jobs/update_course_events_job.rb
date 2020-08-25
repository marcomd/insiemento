class UpdateCourseEventsJob < ApplicationJob
  queue_as :course_events

  def perform(*args)
    CourseEvent.where(state: :active).where('event_date < ?', Time.zone.now).update_all state: :closed
  end
end
