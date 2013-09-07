require 'spec_helper'

describe Project do
  let!(:project) { FactoryGirl.create(:project) }
  let(:donation) { FactoryGirl.create(:donation) }

  it 'has a valid factory' do
    project.should be_valid  
  end

  it { should belong_to(:owner) }
  it { should have_many(:donations) }
  it { should have_many(:donators).through(:donations) }

  it { should validate_uniqueness_of(:title) }

  context "has a method hours donated" do
    it { should respond_to(:hours_donated) }

    it "should call method hours on all associated donations" do
      project.donations << donation
      expect(project.hours_donated).to eq donation.hours
    end
  end

  context "has a method hours remaining" do
    it { should respond_to(:hours_remaining) }

    it "should subtract hours goal from hours donated" do
      project.donations << donation
      expected = project.hour_goal - donation.hours
      expect(project.hours_remaining).to eq expected
    end
  end

  context "has a method dollars donated" do
    it { should respond_to(:dollars_donated) }

    it "should call method dollar_amount on each associated donation" do
      project.donations << donation
      expect(project.dollars_donated).to eq donation.dollar_amount
    end
  end

  context "has a method dollars remaining" do
    it { should respond_to(:dollars_remaining) }

    it "should subtract dollars goal from dollars donated" do
      project.donations << donation
      expected = project.dollar_goal - donation.dollar_amount
      expect(project.dollars_remaining).to eq expected
    end
  end

  context "has a method time remaining" do
    it { should respond_to(:time_remaining) }

    it "should return how many days are left until the deadline" do
      expect(project.time_remaining).to be_between(29, 30)
    end
  end
end
