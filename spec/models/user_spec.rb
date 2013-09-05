require 'spec_helper'

describe User do
  let!(:user) { FactoryGirl.create(:user) }

  it 'has a valid factory' do
    user.should be_valid
  end

  it { should have_many(:created_projects) }
  it { should have_many(:donations) }
  it { should have_many(:donated_projects).through(:donations) }

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:email) }
end
