#
# Add new events as defined in scheduling
#
require 'English'
class ScheduleService
  prepend SimpleCommand

  def initialize(starting_date: Time.zone.today, organization_ids: [], debug: false)
    @starting_date = starting_date
    @progressive_date = starting_date
    @organization_ids = organization_ids
    @debug = debug
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  def call
    created_course_events = 0

    organizations.find_each do |organization|
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
  # rubocop:enable Metrics/CyclomaticComplexity

  private

  attr_reader :starting_date, :progressive_date, :debug, :organization_ids

  def build_course_events(organization)
    CourseSchedule.where(organization_id: organization.id).active.order('event_day, event_time, course_id').map do |cs|
      ce = {
        organization_id: cs.organization_id,
        category_id: cs.category_id,
        course_id: cs.course_id,
        room_id: cs.room_id,
        trainer_id: cs.trainer_id,
        course_schedule_id: cs.id,
        event_date: cs.next_event_datetime(progressive_date),
        state: cs.state,
      }
      @progressive_date = ce[:event_date].to_date - 1 # It makes sure the next event calculation starts from the event date
      ce
    end
  end

  def organizations
    @organizations ||= organization_ids.present? ? Organization.where(id: organization_ids) : Organization.active
  end
end
# rubocop:enable Metrics/AbcSize
