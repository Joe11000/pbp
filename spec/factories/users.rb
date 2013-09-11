FactoryGirl.define do
  factory :user, aliases: [:owner] do
    sequence(:email) { |n| "bob#{n}@gmail.com" }
    first_name            "Bob"
    last_name             "Jones"
    location              "Chicago"
    fb_uid                "1234"
    fb_nickname           "bobbyj"
    nickname              "bobbyj"
    fb_avatar_url         "www.pic.com"
    fb_oauth              "1234"
    password_digest       "apassworddigest"
    fb_ouath_expires_at = "1"

    after(:build) do |user|
      user.set_customer_token
    end
  end
end
