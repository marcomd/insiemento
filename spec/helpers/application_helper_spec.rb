require 'spec_helper'

describe ApplicationHelper do
  describe '#get_organization_domain' do
    let(:result) { helper.get_organization_domain(organization) }

    let(:organization) { user_stefania.organization }

    context 'when the organization has a domain' do
      it { expect(result).to eq('www.fitness.io') }
    end

    context 'when the organization has a subdomain' do
      before { organization.domain = 'fitness' }
      it { expect(result).to eq('fitness.localhost') }
    end
  end
end
