#
# Add penalties to users that misses booked sessions
#
# rubocop:disable Metrics/AbcSize
class PenaltyService
  prepend SimpleCommand

  def initialize(starting_date: Time.zone.yesterday, debug: false)
    @starting_date = starting_date.is_a?(String) ? Date.parse(starting_date) : starting_date
    @debug = debug
  end

  def call
    created_penalties_size_for_all_organizations = 0
    Organization.active.find_each do |organization|
      puts "Organization id #{organization.id}: #{organization.name}" if debug && !Rails.env.test?
      created_penalties_size_for_all_organizations += create_penalties(organization:)
    end

    created_penalties_size_for_all_organizations
  end

  private

  attr_reader :starting_date, :debug

  def create_penalties(organization:)
    created_penalties_size_for_organization = 0
    Penalty.active_state.where(organization_id: organization.id).find_each do |penalty|
      puts "Penalty id #{penalty.id} category #{penalty.category_id} course #{penalty.course_id} days #{penalty.days}" if debug && !Rails.env.test?
      penalties = build_penalties_searching_course_events(penalty:, organization:)

      if debug
        puts penalties unless Rails.env.test?
      else
        created_penalties = UserPenalty.create(records)
        created_penalties_size_for_organization += created_penalties.select { |record| record.id.present? }.size
      end
    end
    created_penalties_size_for_organization
  end

  def build_penalties_searching_course_events(penalty:, organization:)
    penalties = []
    course_event_search_attributes = { organization_id: organization.id }
    course_event_search_attributes[:category_id] = penalty.category_id if penalty.category_id
    course_event_search_attributes[:course_id] = penalty.course_id if penalty.course_id
    CourseEvent.where('event_date >= ? and event_date < ?', starting_date, starting_date + 1).where(course_event_search_attributes).find_each do |course_event|
      puts "CourseEvent id #{course_event.id} course #{course_event.course_id}" if debug && !Rails.env.test?
      penalties.push(*build_penalties_searching_attendees(penalty:, course_event:, course_event_search_attributes:))
    end
    penalties
  end

  def build_penalties_searching_attendees(penalty:, course_event:, course_event_search_attributes:)
    penalties = []
    course_event.attendees.where(presence: false).find_each do |attendee|
      next unless course_event.event_date

      puts "Attendee id #{attendee.id} presence #{attendee.presence}" if debug && !Rails.env.test?
      inhibited_until = course_event.event_date.to_date + penalty.days
      penalties << course_event_search_attributes.merge({ course_event_id: course_event.id,
                                                          course_id: penalty.course_id,
                                                          subscription_id: attendee.subscription_id,
                                                          user_id: attendee.user_id,
                                                          attendee_id: attendee.id,
                                                          inhibited_until: })
      # attendee.disable_bookability_checks = true
      # attendee.update inhibited_until: inhibited_until unless debug
    end
    penalties
  end
end
# rubocop:enable Metrics/AbcSize
