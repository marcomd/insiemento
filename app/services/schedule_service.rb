#
# Add new events as defined in scheduling
#
class ScheduleService
  prepend SimpleCommand

  attr_reader :starting_date, :debug

  def initialize(starting_date: Time.zone.today, debug: false)
    @starting_date = starting_date
    @debug = debug
  end

  def call
    progressive_date = starting_date
    attribute_course_events = []
    CourseSchedule.active.each do |cs|
      ce = {  organization_id: cs.organization_id,
              category_id: cs.category_id,
              course_id: cs.course_id,
              room_id: cs.room_id,
              trainer_id: cs.trainer_id,
              course_schedule_id: cs.id,
              event_date: cs.next_event_datetime(progressive_date),
              state: cs.state
      }
      if debug
        puts "CourseEvent #{ce}" unless Rails.env.test?
      else
        attribute_course_events << ce
      end
      progressive_date = ce[:event_date].to_date - 1
    end
    CourseEvent.create!(attribute_course_events) if attribute_course_events.present?
    true
  end

  private



end
