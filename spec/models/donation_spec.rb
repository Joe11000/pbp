require 'spec_helper'

describe Donation do
  let(:donation) { FactoryGirl.create(:donation) }

  it 'has a valid factory' do
    donation.should be_valid
  end

  it { should belong_to(:user) }
  it { should belong_to(:project) }

  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:project) }

  it { should validate_numericality_of(:dollar_amount) }
end
