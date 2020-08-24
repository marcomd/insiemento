require 'rails_helper'

RSpec.describe Attendee, type: :model do
  subject { Attendee.new(user_id: user.id, course_event_id: course_event_id) }

  describe '#create' do
    let(:result) { subject.save }
    let(:course_event) { CourseEvent.find course_event_id }

    context 'when user can attendee' do
      let(:user) { user_stefania }
      let(:course_event_id) { stefania_unsubscribed_course_event_id }

      it do
        Timecop.freeze(course_event.event_date - 12.hours) do
          expect(result).to be_truthy
        end
      end
      it do
        Timecop.freeze(course_event.event_date - 12.hours) do
          expect { result }.to change(Attendee, :count).by(1)
        end
      end
    end

    context 'when user cannot attendee' do
      let(:user) { user_stefania }
      let(:course_event_id) { stefania_subscribed_course_event_id }

      it { expect(result).to be_falsey }
      it do
        result
        expect(subject.errors).to be_present
      end
    end
  end

  describe '#check_max_attendees' do
    let(:result) { subject.send(:check_max_attendees) }
    let(:user) { user_stefania }
    let(:course_event_id) { stefania_unsubscribed_course_event_id }

    it { expect(result).to be_nil }

    context 'when course events is full' do
      let(:course_event_id) { stefania_subscribed_course_event_id }
      it { expect(result).to include 'È stato raggiunto il numero massimo di partecipanti!' }
    end
  end

  describe '#check_valid_subscriptions' do
    let(:result) { subject.send(:check_valid_subscriptions) }

    context 'when user has a valid subscription' do
      let(:user) { user_stefania }
      let(:course_event_id) { stefania_unsubscribed_course_event_id }
      it { expect(result).to be_truthy }
    end

    context 'when user does NOT have a valid subscription' do
      let(:user) { user_elena }
      let(:course_event_id) { 1 }
      it { expect(result).to be_falsey }
    end
  end

  describe '#check_course_event_bookability' do
    let(:result) { subject.send(:check_course_event_bookability, check_datetime) }
    let(:user) { user_stefania }
    let(:course_event_id) { stefania_unsubscribed_course_event_id }
    let(:course_event) { CourseEvent.find(course_event_id) }

    context 'when booking time is correct' do
      let(:check_datetime) { course_event.event_date - 8.hours }
      it { expect(result).to be_truthy }
      it do
        result
        expect(subject.errors).to_not be_present
      end
    end

    context 'when booking time is too late' do
      let(:check_datetime) { course_event.event_date - 15.minutes }
      it { expect(result).to be_falsey }
      it do
        result
        expect(subject.errors).to be_present
      end
    end
  end

  describe '#check_course_event_unsubscribable' do
    let(:result) { subject.send(:check_course_event_unsubscribable, check_datetime) }
    let(:user) { user_stefania }
    let(:course_event_id) { stefania_subscribed_course_event_id }
    let(:course_event) { CourseEvent.find(course_event_id) }

    context 'when booking time allows unsubscription' do
      let(:check_datetime) { course_event.event_date - 8.hours }
      it { expect(result).to be_truthy }
      it do
        result
        expect(subject.errors).to_not be_present
      end
    end

    context 'when booking time does NOT allow unsubscription' do
      let(:check_datetime) { course_event.event_date - 15.minutes }
      it do
        expect do
          expect(result).to be_falsey
          expect(subject.errors).to be_present
        end.to raise_exception UncaughtThrowError
      end
    end
  end
end
