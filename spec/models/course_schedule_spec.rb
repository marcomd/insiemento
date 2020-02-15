require 'rails_helper'

RSpec.describe CourseSchedule, type: :model do

  describe '#next_event_date' do
    let(:result) { subject.next_event_date starting_date }

    context 'when scheduling a monday' do
      subject { described_class.where(event_day: :monday).first }

      context 'when starting date id sunday 9 feb' do
        let(:starting_date) { Date.parse '2020-02-09' }
        let(:expected_date) { Date.parse '2020-02-10' }

        it 'returns the monday 10 feb' do
          expect(result).to eq expected_date
        end
      end

      context 'when starting date id monday 10 feb' do
        let(:starting_date) { Date.parse '2020-02-10' }
        let(:expected_date) { Date.parse '2020-02-17' }

        it 'returns the monday 10 feb' do
          expect(result).to eq expected_date
        end
      end
    end

    context 'when scheduling a sunday' do
      subject { described_class.where(event_day: :sunday).first }

      context 'when starting date id sunday 9 feb' do
        let(:starting_date) { Date.parse '2020-02-08' }
        let(:expected_date) { Date.parse '2020-02-09' }

        it 'returns the sunday 9 feb' do
          expect(result).to eq expected_date
        end
      end

      context 'when starting date id monday 10 feb' do
        let(:starting_date) { Date.parse '2020-02-09' }
        let(:expected_date) { Date.parse '2020-02-16' }

        it 'returns the sunday 16 feb' do
          expect(result).to eq expected_date
        end
      end
    end
  end

  describe '#next_event_datetime' do
    let(:result) { subject.next_event_datetime starting_date }

    context 'when scheduling a monday' do
      subject { described_class.where(event_day: :monday).first }

      context 'when starting date id sunday 9 feb' do
        let(:starting_date) { Date.parse '2020-02-09' }
        let(:expected_date) { Time.zone.parse '2020-02-10 7:00' }

        it 'returns the monday 10 feb' do
          expect(result).to eq expected_date
        end
      end
    end
  end
end
