require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#has_active_document?' do
    let(:result) { subject.has_active_document?(user_document_model_id) }
    let(:user_document_model_id) { 1 }

    context 'when user has an active document' do
      subject { user_stefania }
      it { expect(result).to be_truthy }
    end

    context 'when user does NOT have an active document' do
      subject { user_paolo }
      it { expect(result).to be_falsey }
    end
  end

  describe '#set_state' do
    let(:result) { subject.send(:set_state) }

    context 'when user has an active subscription' do
      subject { user_stefania }

      context 'when user is active' do
        it do
          expect do
            expect(subject.active_state?).to be_truthy
            result
          end.to_not change(subject, :state)
        end
      end

      context 'when user is NOT active' do
        before { subject.state = :new }
        it do
          expect do
            expect(subject.active_state?).to be_falsey
            result
          end.to change(subject, :state).to('active')
        end
      end
    end

    context 'when user does NOT have an active subscription' do
      subject { user_elena }

      context 'when user is active' do
        before { subject.state = :active }
        it do
          expect do
            expect(subject.active_state?).to be_truthy
            result
          end.to change(subject, :state).to('suspended')
        end
      end

      context 'when user is new' do
        before { subject.state = :new }
        it do
          expect do
            expect(subject.active_state?).to be_falsey
            result
          end.to_not change(subject, :state)
        end
      end

      context 'when user is suspended' do
        before { subject.state = :suspended }
        it do
          expect do
            expect(subject.active_state?).to be_falsey
            result
          end.to_not change(subject, :state)
        end
      end
    end
  end

  describe '#is_inhibited?' do
    subject { user_stefania }
    let(:result) { subject.is_inhibited?(category_id: category_id, course_id: course_id) }
    let(:category_id) { nil }
    let(:course_id) { nil }

    it { expect(result).to eq false }

    context 'when there is an inhibition' do
      # before { user_stefania.attendees.first.update_column(:inhibited_until, Time.zone.tomorrow) }
      before { create(:user_penalty, user: subject) }

      it do
        expect(result).to eq true
      end
    end
  end

  describe '.with_not_ended_subscriptions' do
    let(:result) { described_class.with_not_ended_subscriptions }

    it { expect(result.size).to eq 4 }
  end

  describe '.elegible_for_user_documents' do
    let(:result) { described_class.elegible_for_user_documents }

    it { expect(result.size).to eq 13 }
  end
end
