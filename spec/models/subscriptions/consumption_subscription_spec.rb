require 'rails_helper'

RSpec.describe ConsumptionSubscription, type: :model do

  subject { user_linda.active_subscriptions.where(subscription_type: 'consumption').first }

  describe '#set_current_state' do
    let(:result) { subject.send(:set_current_state, current_date) }
    let(:current_date) { Date.new(2020,8,2) }

    before do
      subject.start_on = '2020-08-02'
      subject.end_on = '2020-08-03'
    end

    it { expect(result).to eq 'active' }

    context 'when max_accesses_number is reached' do
      before { subject.max_accesses_number = 0 }
      it { expect(result).to eq 'consumed' }
    end

    context 'when max attendees is reached' do
      let(:course_event_id) { stefania_unsubscribed_course_event_id }
      before { subject.max_accesses_number = 1 }

      it do
        expect(subject.add_attendee(course_event_id).persisted?).to be_truthy
        expect(result).to eq 'consumed'
      end
    end
  end

end
