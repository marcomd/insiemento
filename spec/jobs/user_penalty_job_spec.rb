require 'rails_helper'

RSpec.describe UserPenaltyJob, type: :job do
  include ActiveJob::TestHelper

  subject { described_class.perform_later }
  let(:organization) { organization_fitness }
  let(:category) { category_fitness }
  let(:course) { course_fitness_zumba }
  let(:penalty) { create(:penalty, organization: organization, category: category) }
  let(:event_date) { 1.day.ago }
  let(:course_event) do
    create(:course_event,
           organization: organization,
           category: category,
           course: course,
           state: :active,
           event_date: event_date)
  end
  # Dopo il seed lo user è senza abbonamento, verificare
  let(:user) { user_linda }
  let(:attendee) { create(:attendee, user: user, course_event: course_event, presence: presence, disable_bookability_checks: true) }
  let(:presence) { false }

  context 'when job is enqueued' do
    # We reset the queue manually so as not to affect next tests
    after {clear_enqueued_jobs}

    it { expect { subject }.to change(enqueued_jobs, :size).by(1) }

    it 'is in the proper queue' do
      expect(described_class.new.queue_name).to eq('users')
    end
  end

  context 'when job is performed' do
    context 'when course event does NOT exists' do
      before do
        Attendee.update_all(presence: true)
        penalty
        attendee
      end

      it do
        expect do
          perform_enqueued_jobs { subject }
        end.to change(UserPenalty, :count).by(1)
      end
    end

    # context 'when course event already exists' do
    #   it do
    #     expect do
    #       perform_enqueued_jobs{ subject }
    #     end.to change(SystemLog, :count).by(2)
    #   end
    # end
  end
end
