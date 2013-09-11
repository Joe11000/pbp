require 'spec_helper'

describe UserMailer do

  around(:each) do |example|
    VCR.use_cassette('balanced') do
      example.run
    end
  end

  context 'it formats the welcome email properly' do
    let(:user) { FactoryGirl.create(:user) }
    let(:mail) { UserMailer.welcome_email(user) }

    it 'should render the subject' do
      expect( mail.subject ).to eq 'Welcome to Park Bench Projects'
    end

    it 'should render the receiver email' do
      expect( mail.to ).to eq [user.email]
    end

    it 'it should render the sender email' do
      expect( mail.from ).to eq ['notifications@parkbenchprojects.com']
    end

    it 'should have a value for first_name' do
      expect( mail.body.encoded ).to match(user.first_name)
    end

    it 'should have the proper message content' do
      expect( mail.body.encoded).to match( "Hey, Bob We're glad you have signed up with Park Bench Projects.  This is going to be awesome.")
    end

    it 'should have the proper title content' do
      expect( mail.body.encoded ).to match("Welcome to Park Bench Projects")
    end
  end
end
