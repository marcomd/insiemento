require 'rails_helper'

RSpec.describe Payment, type: :model do
  context 'ActiveRecord' do
    it { expect(subject).to belong_to(:organization) }
    it { expect(subject).to belong_to(:user).optional }
    it { expect(subject).to belong_to(:order).optional }
  end

  subject { build(:payment) }

  context '#create' do
    let(:result) do
      VCR.use_cassette "generic_sendgrid/create_user" do
        subject.save
      end
    end

    before { ENV['ORGANIZATION']='1' }

    it { expect(result).to be_truthy }

    it 'update order paid amounts' do
      allow(subject).to receive(:update_order!)
      result
      expect(subject).to have_received(:update_order!).once
    end

    it { expect { result }.to change(described_class, :count).by(1) }
  end
end
