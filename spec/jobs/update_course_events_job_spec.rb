require 'rails_helper'

RSpec.describe UpdateCourseEventsJob, type: :job do
  include ActiveJob::TestHelper

  subject { described_class.perform_later }

  context 'when job is enqueued' do
    # We reset the queue manually so as not to affect next tests
    after {clear_enqueued_jobs}

    it { expect { subject }.to change(enqueued_jobs, :size).by(1) }

    it 'is in the proper queue' do
      expect(described_class.new.queue_name).to eq('course_events')
    end
  end

  context 'when job is performed' do
    let!(:course_event) do
      create(:course_event, event_date: event_date, state: :active, organization_id: 1, category_id: 1, course_id: 1, course_schedule_id: 1, room_id: 1, trainer_id: 1)
    end

    context 'when event is expired many time ago' do
      let(:event_date) { 2.hours.ago }
      it do
        expect do
          perform_enqueued_jobs{ subject }
          course_event.reload
        end.to change(course_event, :state).from('active').to('closed')
      end
    end

    context 'when event is expired little time ago' do
      let(:event_date) { 16.minutes.ago }
      it do
        expect do
          perform_enqueued_jobs{ subject }
          course_event.reload
        end.to change(course_event, :state).from('active').to('closed')
      end
    end

    context 'when event is just expired' do
      let(:event_date) { 14.minutes.ago }
      it do
        expect do
          perform_enqueued_jobs{ subject }
          course_event.reload
        end.to_not change(course_event, :state)
      end
    end

    context 'when event is NOT expired' do
      let(:event_date) { 5.minutes.from_now }
      it do
        expect do
          perform_enqueued_jobs{ subject }
          course_event.reload
        end.to_not change(course_event, :state)
      end
    end
  end
end
