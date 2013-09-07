FactoryGirl.define do
  factory :donation do
    user
    project
    hours         10
    dollar_amount 1000
  end
end
