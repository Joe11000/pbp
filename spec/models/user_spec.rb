require 'spec_helper'

describe User do
  let(:user) { FactoryGirl.create(:user) }

  let(:bank_account) {{:account_number => '9900000002',
                       :name => user.first_name + " " + user.last_name,
                       :routing_number => '021000021',
                       :type => 'checking'}}

  it 'has a valid factory' do
    user.should be_valid
  end

  it { should have_many(:created_projects) }
  it { should have_many(:donations) }
  it { should have_many(:donated_projects).through(:donations) }

  context "it send a bunch of lovely emails" do
    it { should respond_to(:send_welcome) }

    it "should send a welcome email" do
      user.send_welcome
      expect( ActionMailer::Base.deliveries.last.to ).to eq [user.email]
    end
  end

  context "it has a method balanced_customer" do
    it { should respond_to(:balanced_customer) }

    it "should get a customer" do
      user.balanced_customer
      expect( user.balanced_customer.uri ).to_not eq nil
    end
  end

  context "it has a method set_customer_token" do
    it { should respond_to(:set_customer_token) }
    it { should respond_to(:get_card_token) }

    it "should get a card token" do
       expect( user.get_card_token ).to match(/^\/v1\/marketplaces\/TEST-MPv0uxteFANO0h9xY5c6Lrq\/cards\//)
    end

    it "should set a customer token in the database" do
      user.set_customer_token(user.get_card_token)
      expect( user.balanced_customer_uri ).to_not eq nil
    end
  end

  context "it has a method set_bankaccount_token" do
    it { should respond_to(:set_bankaccount_token) }
    it { should respond_to(:get_bankaccount_token) }

    it "should get a bank account token" do
       user.get_bankaccount_token(bank_account)
       expect( user.get_bankaccount_token(bank_account) ).to match(/^\/v1\/bank_accounts/)
    end

    it "should set a customer token in the database" do
      bank_account_token = user.get_bankaccount_token(bank_account)
      user.set_bankaccount_token(bank_account_token)
      user.save
    end
  end

  context "class has a method find_or_create_from_omniauth" do
    it "should return a user" do
      expect( User.find_or_create_from_omniauth(add_user_mock).class).to eq User
    end

    it "should differentiate between facebook and twitter" do
      expect( User.find_or_create_from_omniauth(add_user_mock).twitter_uid ).to eq nil
      expect( User.find_or_create_from_omniauth(add_user_mock(provider: "twitter")).fb_uid ).to eq nil
    end
  end

  context "class has a method find_or_create_from_twitter" do
    it "should create a user if no user currently has that twitter_uid" do
      expect {
        User.find_or_create_from_twitter(add_user_mock(provider: "twitter"))
      }.to change(User, :count).by 1
    end

    it "should return an existing user with that twitter id" do
      FactoryGirl.create(:user)
      auth = add_user_mock(provider: "twitter")
      expect( User.find_or_create_from_twitter(auth).twitter_uid ).to eq "1234"
    end
  end

  context "class has a method find_or_create_from_facebook" do
    it "should create a user if no user currently has that fb_uid" do
      expect {
        User.find_or_create_from_facebook(add_user_mock)
      }.to change(User, :count).by 1
    end

    it "should return an existing user with that facebook id" do
      FactoryGirl.create(:user)
      expect( User.find_or_create_from_twitter(add_user_mock).fb_uid ).to eq "1234"
    end
  end
end
