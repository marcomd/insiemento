require 'rails_helper'

describe UpdateSubscriptionsJob do
  include ActiveJob::TestHelper

  context 'when job is enqueued' do
    subject { described_class.perform_later }

    # We reset the queue manually so as not to affect next tests
    after { clear_enqueued_jobs }

    it { expect { subject }.to change(enqueued_jobs, :size).by(1) }

    it 'is in the proper queue' do
      expect(described_class.new.queue_name).to eq('users')
    end
  end

  context 'when job is performed' do
    subject { described_class.perform_now }

    context 'when active subscription have to be suspended' do
      let(:subscription) { create(:subscription, state: :active, organization_id: 1, start_on: 1.month.ago, end_on: Time.zone.tomorrow) }

      before { subscription.update_column(:end_on, Time.zone.yesterday) }

      it do
        expect do
          subject
          subscription.reload
        end.to change(subscription, :state).from('active').to('expired')
      end
    end

    context 'when unactive subscription have to be activated' do
      let(:subscription) { create(:subscription, state: :new, organization_id: 1, start_on: Time.zone.tomorrow, end_on: 2.days.from_now) }

      before do
        subscription.update_column(:start_on, Time.zone.yesterday)
      end

      it do
        expect do
          subject
          subscription.reload
        end.to change(subscription, :state).from('new').to('active') # because it has an active subscription
      end
    end
  end
end
