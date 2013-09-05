require 'spec_helper'

describe Project do
  let!(:project) { FactoryGirl.create(:project) }

  it 'has a valid factory' do
    project.should be_valid  
  end

  it { should belong_to(:owner) }
  it { should have_many(:donations) }
  it { should have_many(:donators).through(:donations) }

  it { should validate_uniqueness_of(:title) }  
end
