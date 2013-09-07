FactoryGirl.define do
  factory :user_with_card do
    sequence(:email) { |n| "bob#{n}@gmail.com" }
    first_name "Bob"
    last_name "Jones"
    location "Chicago"
    fb_uid "1234"
    fb_nickname "bobbyj"
    fb_avatar_url "www.pic.com"
    fb_oauth "1234"
    fb_ouath_expires_at = "1"

    after_build do |user_with_card|
      card = {:uri => "/v1/marketplaces/TEST-MPv0uxteFANO0h9xY5c6Lrq/cards",
                     :name => user_with_card.first_name,
                     :email => user_with_card.email,
                     :card_number => "4111111111111111",
                     :expiration_month => "10",
                     :expiration_year => "2020"}
      card_token = user_with_card.get_card_token(card)
      user_with_card.set_customer_token(card_token)
    end
  end
end
