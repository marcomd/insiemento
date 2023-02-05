#
# Add new events as defined in scheduling
#
# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/CyclomaticComplexity
require 'English'
class ScheduleService
  prepend SimpleCommand

  def initialize(starting_date: Time.zone.today, debug: false)
    @starting_date = starting_date
    @progressive_date = starting_date
    @debug = debug
  end

  def call
    created_course_events = 0
    Organization.active.find_each do |organization|
      puts "Organization id #{organization.id}: #{organization.name}" if debug && !Rails.env.test?
      organization_course_events = build_course_events(organization)
      next if organization_course_events.blank?
      puts organization_course_events if debug && !Rails.env.test?

      begin
        CourseEvent.create!(organization_course_events) unless debug
        created_course_events += organization_course_events.size
      rescue StandardError => e
        SystemLog.create!(message: e.message, log_level: :error, organization_id: organization.id)
      end
    end

    created_course_events
  end

  private

  attr_reader :starting_date, :progressive_date, :debug

  def build_course_events(organization)
    organization_course_events = []
    CourseSchedule.active.where(organization_id: organization.id).order('event_day, event_time, course_id').find_each do |cs|
      ce = {  organization_id: cs.organization_id,
              category_id: cs.category_id,
              course_id: cs.course_id,
              room_id: cs.room_id,
              trainer_id: cs.trainer_id,
              course_schedule_id: cs.id,
              event_date: cs.next_event_datetime(progressive_date),
              state: cs.state }
      @progressive_date = ce[:event_date].to_date - 1
      organization_course_events << ce
    end
    organization_course_events
  end
end
# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/CyclomaticComplexity
