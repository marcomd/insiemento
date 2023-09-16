require 'rails_helper'

describe Course do
  context 'ActiveRecord' do
    it { expect(subject).to belong_to(:organization) }
    it { expect(subject).to belong_to(:category) }

    it { expect(subject).to have_many(:course_events) }
    it { expect(subject).to have_many(:course_schedules) }
    it { expect(subject).to have_many(:trainers) }
    it { expect(subject).to have_many(:rooms) }

    it { expect(subject).to validate_numericality_of(:start_booking_hours).is_greater_than_or_equal_to(0).is_less_than(10_000) }
    it { expect(subject).to validate_numericality_of(:end_booking_minutes).is_greater_than_or_equal_to(0).is_less_than(10_000) }
    it { expect(subject).to validate_presence_of(:name) }
  end
end
