FactoryGirl.define do
  factory :user, aliases: [:owner] do
    name "Bob"
    sequence(:email) { |n| "bob#{n}@gmail.com" }
  end
end
