require "spec_helper"

describe ApplicationHelper, type: :helper do
  describe "#get_user_domain" do
    let(:result) { helper.get_user_domain(user) }

    let(:user) { user_stefania }

    context 'when the user organization has a domain' do
      it { expect(result).to eq 'fitness.io' }
    end

    context 'when the user organization has a subdomain' do
      before { user.organization.domain = 'fitness' }
      it { expect(result).to eq 'fitness.localhost' }
    end
  end
end