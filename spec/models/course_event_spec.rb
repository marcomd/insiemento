require 'rails_helper'

describe CourseEvent do
  context 'ActiveRecord' do
    it { expect(subject).to belong_to(:organization) }
    it { expect(subject).to belong_to(:category) }
    it { expect(subject).to belong_to(:course) }
    it { expect(subject).to belong_to(:room) }
    it { expect(subject).to belong_to(:trainer) }
    it { expect(subject).to belong_to(:course_schedule) }
    # it { expect(subject).to belong_to(:auditor) }

    it { expect(subject).to have_many(:attendees) }
  end
end
