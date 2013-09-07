require 'spec_helper'

describe User do
  let(:user) { FactoryGirl.create(:user) }
  let(:card) {{:uri => "/v1/marketplaces/TEST-MPv0uxteFANO0h9xY5c6Lrq/cards",
                     :name => user.first_name,
                     :email => user.email,
                     :card_number => "4111111111111111",
                     :expiration_month => "10",
                     :expiration_year => "2020"}}

  it 'has a valid factory' do
    user.should be_valid
  end

  it { should have_many(:created_projects) }
  it { should have_many(:donations) }
  it { should have_many(:donated_projects).through(:donations) }
  it { should validate_uniqueness_of(:email) }
  it { should validate_presence_of(:email) }

  context "it has a method set_customer_token" do
    it { should respond_to(:set_customer_token) }
    it { should respond_to(:get_card_token) }

    it "should get a card token" do
       expect( user.get_card_token(card) ).to match(/^\/v1\/marketplaces\/TEST-MPv0uxteFANO0h9xY5c6Lrq\/cards\//)
    end

    it "should set a customer token in the database" do
      card_token = user.get_card_token(card)
      user.set_customer_token(card_token)
      expect( user.balanced_customer_uri ).to_not eq nil
    end
  end
end
