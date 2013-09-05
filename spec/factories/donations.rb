FactoryGirl.define do
  factory :donation do
    user
    project
    hours         10
    dollar_amount "10.00"
  end
end
