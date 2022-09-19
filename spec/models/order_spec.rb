require 'rails_helper'

RSpec.describe Order, type: :model do
  context 'ActiveRecord' do
    it { expect(subject).to belong_to(:organization)}
    it { expect(subject).to belong_to(:user)}
    it { expect(subject).to have_many(:order_products)}
    it { expect(subject).to have_many(:products)}
    it { expect(subject).to have_many(:payments)}
  end

  let(:organization) { build(:organization) }
  let(:product1) { build(:product, organization: organization) }
  let(:product2) { build(:product, organization: organization) }

  context '#create' do
    subject { build(:order, organization: organization) }
    let(:result) do
      VCR.use_cassette 'generic_sendgrid/create_user' do
        subject.save
      end
    end

    before { ENV['ORGANIZATION'] = '1' }

    it { expect(result).to be_truthy }

    it 'set amounts' do
      allow(subject).to receive(:set_amounts!)
      result
      expect(subject).to have_received(:set_amounts!).once
    end

    it { expect { result }.to change(described_class, :count).by(1) }
  end

  describe '#set_amounts!' do
    subject { build(:order, organization: organization) }
    let(:result) do
      VCR.use_cassette 'generic_sendgrid/create_user' do
        subject.send :set_amounts!
      end
    end

    it { expect(result).to be_truthy }

    before { ENV['ORGANIZATION'] = '1' }

    context 'when it have products' do
      let(:discount_cents) { 100 }
      subject { build(:order, organization: organization, discount_cents: discount_cents, products: [product1, product2]) }

      it { expect(result).to be_truthy }

      it 'calculates total_amount_cents' do
        result
        expect(subject.total_amount_cents).to eq(product1.price_cents + product2.price_cents)
      end

      it 'calculates amount_to_pay_cents' do
        result
        expect(subject.amount_to_pay_cents).to eq(product1.price_cents + product2.price_cents - discount_cents)
      end
    end
  end

  describe '#set_state!' do
    let(:result) { subject.send :set_state! }

    before { ENV['ORGANIZATION'] = '1' }

    context 'when it have products' do
      subject { build(:order, organization: organization, products: [product1, product2]) }

      before do
        VCR.use_cassette 'generic_sendgrid/create_user' do
          subject.send :set_amounts!
        end
      end

      it 'set the right state' do
        expect(subject.state).to eq 'just_made'
        result
        expect(subject.state).to eq 'processing'
      end
    end
  end

  describe '#update_paid_amounts!' do
    let(:result) { subject.send :update_paid_amounts! }

    context 'when order has confirmed payments' do
      subject { order_with_unconfirmed_payments }

      before { subject.payments.update_all state: :confirmed }

      it do
        result
        expect(subject.amount_paid_cents).to eq 1900
      end
    end

    context 'when order has unconfirmed payments' do
      subject { order_with_unconfirmed_payments }

      it do
        result
        expect(subject.amount_paid_cents).to eq 0
      end
    end

    context 'when order does NOT have any payments' do
      subject { order_without_payments }

      it do
        result
        expect(subject.amount_paid_cents).to eq 0
      end
    end
  end
end
