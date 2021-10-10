class UpdateCourseEventsJob < ApplicationJob
  queue_as :course_events

  def perform
    CourseEvent.where(state: :active).where('event_date < ?', Time.zone.now-70.minutes).update_all(state: :closed)
  end
end
