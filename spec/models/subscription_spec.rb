require 'rails_helper'

describe Subscription do
  describe '#type' do
    subject { build(:subscription, subscription_type:) }
    let(:result) { subject.type }

    context 'when payment type is trial' do
      let(:subscription_type) { :trial }
      it { expect(result).to be_a(TrialSubscription) }
    end

    context 'when payment type is consumption' do
      let(:subscription_type) { :consumption }
      it { expect(result).to be_a(ConsumptionSubscription) }
    end

    context 'when payment type is fee' do
      let(:subscription_type) { :fee }
      it { expect(result).to be_a(FeeSubscription) }
    end
  end

  describe '#create' do
    subject { build(:subscription, subscription_type: :fee, product_id: product.id, state: :active, start_on: '2020-08-02') }
    let(:product) { Product.fee_product_type.first }
    let(:result) { subject.save }

    context 'when event date is active' do
      let(:str_date) { '2020-08-02 12:00:00 +0000' }
      it do
        Timecop.freeze(str_date) do
          expect(result).to be_truthy
          expect(subject.state).to eq('active')
        end
      end
    end

    context 'when event date is expired' do
      let(:str_date) { '2020-09-02 12:00:00 +0000' }
      it do
        Timecop.freeze(str_date) do
          expect(result).to be_truthy
          expect(subject.state).to eq('expired')
        end
      end
    end
  end

  describe '#set_current_state' do
    let(:result) { subject.send(:set_current_state, current_date) }
    subject { build(:subscription, subscription_type: :fee, state: :active, start_on: '2020-08-02', end_on: '2020-08-03') }
    let(:current_date) { Date.new(2020, 8, 2) }

    context 'when start on is in the future' do
      let(:current_date) { Date.new(2020, 8, 1) }
      it { expect(result).to eq('new') }
    end

    context 'when start on is today and end_on in the future' do
      it { expect(result).to eq('active') }
    end

    context 'when start on is passed and end_on is today' do
      let(:current_date) { Date.new(2020, 8, 3) }
      it { expect(result).to eq('active') }
    end

    context 'when start on and end_on are both passed' do
      let(:current_date) { Date.new(2020, 8, 4) }
      it { expect(result).to eq('expired') }
    end
  end

  describe '#add_attendee' do
    let(:result) { subject.add_attendee(course_event_id) }
    subject { user_stefania.active_subscriptions.where(subscription_type: 'fee').first }
    let(:course_event) { CourseEvent.find(course_event_id) }

    context 'when course event is subscribable' do
      let(:course_event_id) { stefania_unsubscribed_course_event_id }
      it do
        Timecop.freeze(course_event.event_date - 12.hours) do
          expect(result.errors).to_not be_present
        end
      end
      it do
        Timecop.freeze(course_event.event_date - 12.hours) do
          expect { result }.to change(Attendee, :count).by(1)
        end
      end
    end

    context 'when course event is NOT subscribable' do
      let(:course_event_id) { stefania_subscribed_course_event_id }
      it { expect(result.errors).to be_present }
      it { expect { result }.to_not change(Attendee, :count) }
    end
  end

  describe '.active_at' do
    subject { described_class }
    let(:result) { subject.active_at(date).count }

    context 'when scope is global' do
      context 'when date is after the end' do
        let(:date) { Date.today + 370.days }
        it { expect(result).to eq(0) }
      end
    end

    context 'when scope is a user' do
      # this user has: 1. subscription annual 2. subscription monthly
      subject { user_stefania }
      let(:result) { subject.subscriptions.active_at(date).count }

      context 'when date is before starting' do
        let(:date) { subject.subscriptions.first.start_on - 1 }
        it { expect(result).to eq(0) }
      end

      context 'when date is at the beginning of the active period' do
        let(:date) { subject.subscriptions.first.start_on }
        it { expect(result).to eq(2) }
      end

      context 'when date is at the end of the active period' do
        let(:date) { subject.subscriptions.first.end_on }
        it { expect(result).to eq(1) }
      end

      context 'when date is after the end' do
        let(:date) { subject.subscriptions.first.end_on + 1 }
        it { expect(result).to eq(0) }
      end
    end
  end
end
