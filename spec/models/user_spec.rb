require 'spec_helper'

describe User do
  let(:user) { FactoryGirl.create(:user) }

  it 'has a valid factory' do
    user.should be_valid
  end

  it { should have_many(:created_projects) }
  it { should have_many(:donations) }
  it { should have_many(:donated_projects).through(:donations) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of(:email) }

  context "it has a method get_customer_token" do
    it { should respond_to(:get_customer_token) }
    it { should respond_to(:get_card_token) }

    it "should get a card token" do
      expect( user.get_card_token.class ).to eq Balanced::Card
    end

    it "should create a customer" do
      expect( user.get_customer_token ).to eq Balanced::Customer
      expect( user.balanced_customer_uri ).to_not eq nil
    end
  end
end
