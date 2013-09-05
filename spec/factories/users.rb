FactoryGirl.define do
  factory :user, aliases: [:owner] do
    name "Bob"
    email "bob@gmail.com"
  end
end
