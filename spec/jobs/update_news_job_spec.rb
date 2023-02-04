require 'rails_helper'

describe UpdateNewsJob do
  include ActiveJob::TestHelper

  subject { described_class.perform_later }

  context 'when job is enqueued' do
    # We reset the queue manually so as not to affect next tests
    after { clear_enqueued_jobs }

    it { expect { subject }.to change(enqueued_jobs, :size).by(1) }

    it 'is in the proper queue' do
      expect(described_class.new.queue_name).to eq('news')
    end
  end

  context 'when job is performed' do
    let!(:news) do
      create(:news, organization_id: 1, expire_on:)
    end

    context 'when news is expired' do
      let(:state) { :active }
      let(:expire_on) { 1.day.ago }

      before { news.update_columns(state:) }

      it do
        expect do
          expect(news).to be_active_state
          perform_enqueued_jobs { subject }
          news.reload
        end.to change(news, :state).from('active').to('expired')
      end

      context 'but it is in draft' do
        let(:state) { :draft }
        it do
          expect do
            expect(news).to be_draft_state
            perform_enqueued_jobs { subject }
            news.reload
          end.to_not change(news, :state)
        end
      end
    end

    context 'when news is NOT expired' do
      let(:state) { :active }
      let(:expire_on) { 1.day.from_now }
      it do
        expect do
          perform_enqueued_jobs { subject }
          news.reload
        end.to_not change(news, :state)
      end
    end
  end
end
