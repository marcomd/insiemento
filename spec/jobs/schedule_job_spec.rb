require 'rails_helper'

RSpec.describe ScheduleJob, type: :job do
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
    context 'when course event does NOT exists' do
      before do
        CourseSchedule.update_all state: :suspended
        CourseSchedule.first.update state: :active
      end

      it do
        Timecop.freeze 2.weeks.from_now do
          expect do
            perform_enqueued_jobs{ subject }
          end.to change(CourseEvent, :count).by(1)
        end
      end
    end

    context 'when course event already exists' do
      it do
        expect do
          perform_enqueued_jobs{ subject }
        end.to raise_exception(ActiveRecord::RecordInvalid, /Course already exists/)
      end
    end
  end
end
