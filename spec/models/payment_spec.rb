require 'rails_helper'

describe Payment do
  context 'ActiveRecord' do
    it { expect(subject).to belong_to(:organization) }
    it { expect(subject).to belong_to(:user).optional }
    it { expect(subject).to belong_to(:order).optional }
  end
end
