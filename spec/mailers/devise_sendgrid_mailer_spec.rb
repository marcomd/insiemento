require 'rails_helper'

describe DeviseSendgridMailer do
  describe '#confirmation_instructions' do
    let(:user)    { User.first }
    let(:token)   { 'qwerty12345' }

    subject { described_class.confirmation_instructions(user, token) }

    it do
      pending 'DeviseSendgridMailer.confirmation_instructions is not called, check it'
      allow(SendgridMailer).to receive(:account_confirmation)
      subject
      expect(SendgridMailer).to have_received(:account_confirmation) # .with(:link_url)
    end

    it { expect(subject).to_not be_nil }
  end
end
