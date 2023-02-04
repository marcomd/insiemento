require 'rails_helper'

describe UpdateUsersJob, type: :job do
  include ActiveJob::TestHelper

  subject { described_class.perform_later }

  context 'when job is enqueued' do
    # We reset the queue manually so as not to affect next tests
    after { clear_enqueued_jobs }

    it { expect { subject }.to change(enqueued_jobs, :size).by(1) }

    it 'is in the proper queue' do
      expect(described_class.new.queue_name).to eq('users')
    end
  end

  context 'when job is performed' do
    context 'when active user have to be suspended' do
      let(:user) { create(:user, state: :new, organization_id: 1) }

      before { User.where(id: user.id).update_all(state: :active) }
      it do
        user.reload
        expect do
          perform_enqueued_jobs { subject }
          user.reload
        end.to change(user, :state).from('active').to('suspended') # because it does not have any subscription
      end
    end

    context 'when unactive user have to be activate' do
      let(:user) { user_stefania }
      before { User.where(id: user_stefania.id).update_all(state: :new) }
      it do
        user.reload
        expect do
          perform_enqueued_jobs { subject }
          user.reload
        end.to change(user, :state).from('new').to('active') # because it has an active subscription
      end
    end
  end
end
