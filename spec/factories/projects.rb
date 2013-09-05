FactoryGirl.define do
  factory :project do
    owner
    title       "A Test"
    description "A test project that requires lots of stuff and doing."
    hour_goal   100
    dollar_goal 100.00
  end
end
