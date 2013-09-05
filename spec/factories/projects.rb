FactoryGirl.define do
  factory :project do
    owner
    sequence(:title) { |n| "title#{n}" }
    description "A test project that requires lots of stuff and doing."
    hour_goal   100
    dollar_goal 100.00
    deadline (DateTime.now + 30)
  end
end
