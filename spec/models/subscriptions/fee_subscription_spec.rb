require 'rails_helper'

RSpec.describe FeeSubscription, type: :model do

  subject { user_stefania.active_subscriptions.where(subscription_type: 'fee').first }

  describe '#set_current_state' do
    let(:result) { subject.send(:set_current_state, current_date) }
    let(:current_date) { Date.new(2020,8,2) }

    before do
      subject.start_on = '2020-08-02'
      subject.end_on = '2020-08-03'
    end

    it { expect(result).to eq 'active' }
  end

end
