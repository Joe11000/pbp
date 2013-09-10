require 'spec_helper'

describe Mediafile do
  let!(:mediafile) { FactoryGirl.create(:mediafile) }

  it { should belong_to(:project)}
  it { should validate_presence_of(:url)}
  it { should validate_presence_of(:name)}
  it { should validate_presence_of(:media_type)}
end
