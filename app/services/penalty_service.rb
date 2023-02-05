#
# Add penalties to users that misses booked sessions
#
class PenaltyService
  prepend SimpleCommand

  def initialize(starting_date: Time.zone.yesterday, debug: false)
    @starting_date = starting_date.is_a?(String) ? Date.parse(starting_date) : starting_date
    @debug = debug
  end

  def call
    all_records_size = 0
    Organization.active.each do |organization|
      puts "Organization id #{organization.id}: #{organization.name}" if debug && !Rails.env.test?
      records = []
      Penalty.active_state.where(organization_id: organization.id).each do |penalty|
        puts "Penalty id #{penalty.id} category #{penalty.category_id} course #{penalty.course_id} days #{penalty.days}" if debug && !Rails.env.test?
        course_event_search_attributes = { organization_id: organization.id }
        course_event_search_attributes[:category_id] = penalty.category_id if penalty.category_id
        course_event_search_attributes[:course_id] = penalty.course_id if penalty.course_id
        CourseEvent.where('event_date >= ? and event_date < ?', starting_date, starting_date + 1).where(course_event_search_attributes).each do |course_event|
          puts "CourseEvent id #{course_event.id} course #{course_event.course_id}" if debug && !Rails.env.test?
          course_event.attendees.where(presence: false).each do |attendee|
            next unless course_event.event_date

            puts "Attendee id #{attendee.id} presence #{attendee.presence}" if debug && !Rails.env.test?
            inhibited_until = course_event.event_date.to_date + penalty.days
            records << course_event_search_attributes.merge({ course_event_id: course_event.id,
                                                              course_id: penalty.course_id,
                                                              subscription_id: attendee.subscription_id,
                                                              user_id: attendee.user_id,
                                                              attendee_id: attendee.id,
                                                              inhibited_until: })
            # attendee.disable_bookability_checks = true
            # attendee.update inhibited_until: inhibited_until unless debug
          end
        end

        if debug
          puts "Penalties #{records}" unless Rails.env.test?
        else
          created_penalties = UserPenalty.create(records)
          all_records_size += created_penalties.select { |record| record.id.present? }.size
        end
      end

      # if records.present?
      #   begin
      #     # UserPenalty.create!(records)
      #     all_records_size += records.size
      #   rescue
      #     SystemLog.create!(message: $!.message, log_level: :error, organization_id: organization.id)
      #   end
      # end
    end

    all_records_size
  end

  private

  attr_reader :starting_date, :debug
end
