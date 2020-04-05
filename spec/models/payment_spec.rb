require 'rails_helper'

RSpec.describe Payment, type: :model do
  context 'ActiveRecord' do
    it { expect(subject).to belong_to(:organization) }
    it { expect(subject).to belong_to(:user).optional }
    it { expect(subject).to belong_to(:order).optional }
  end

  subject { build(:payment) }

  context 'create' do
    let(:result) do
      VCR.use_cassette "generic_sendgrid/create_user" do
        subject.save
      end
    end

    before { ENV['ORGANIZATION']='1' }

    it { expect(result).to be_truthy }

    it 'calls add_to_order! method' do
      allow(subject).to receive(:add_to_order!)
      result
      expect(subject).to have_received(:add_to_order!).once
    end

    it { expect { result }.to change(described_class, :count).by(1) }

    context 'when unconfirmed' do
      it { expect { result }.to_not change { subject.order.amount_paid_cents } }
    end

    context 'when confirmed' do
      subject { build(:payment, state: :confirmed) }

      it { expect { result }.to change { subject.order.amount_paid_cents } }
    end
  end

  context '#confirm!' do
    subject { payment_unconfirmed }
    let(:result) { subject.confirm! }

    it { expect { result }.to change(subject, :state).to('confirmed') }

    it 'calls update_order! method' do
      allow(subject).to receive(:update_order!)
      result
      expect(subject).to have_received(:update_order!).once
    end

    it { expect { result }.to change { subject.order.amount_paid_cents } }
  end
end
