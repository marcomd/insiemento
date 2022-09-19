require 'rails_helper'

RSpec.describe DeviseMailer, type: :mailer do
  describe '#confirmation_instructions' do
    let(:organization) { Organization.first }
    let(:user) { create(:user, organization: organization) }

    let(:mail) { described_class.confirmation_instructions(user, user.confirmation_token) }
    let(:mail_body) { mail.html_part.body } # mail.body.encoded is the result sent to client email but it contains new lines

    it { expect(mail.subject).to eq 'Istruzioni per la conferma' }

    it { expect(mail_body).to include("Ciao #{user.firstname}") }
  end

  describe '#reset_password_instructions' do
    let(:user) { user_paolo }

    let(:mail) { described_class.reset_password_instructions(user, user.reset_password_token) }
    let(:mail_body) { mail.html_part.body } # mail.body.encoded is the result sent to client email but it contains new lines

    it { expect(mail.subject).to eq 'Istruzioni per reimpostare la password' }

    it { expect(mail_body).to include("Ciao #{user.firstname}") }
  end
end
