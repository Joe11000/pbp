require 'spec_helper'

describe Donation do
  let(:donation) { FactoryGirl.create(:donation) }

  it "has a valid factory" do
    donation.should be_valid
  end

  it { should belong_to(:user) }
  it { should belong_to(:project) }

  it { should validate_presence_of(:user) }
  it { should validate_presence_of(:project) }

  it { should validate_numericality_of(:dollar_amount) }

  context "should have a method that debits the donation" do
    let(:user) { FactoryGirl.create(:user) }

    it { should respond_to(:debit_amount) }

    it "should charge the donator the specified amount" do
      donation = user.donations.create(dollar_amount: 10000,
                                       project: FactoryGirl.create(:project))

      expect( donation.debit_amount ).to be_true
    end
  end
end
