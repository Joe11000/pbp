require 'active_support/all'

def create_users(num)
  num.times do
    user = User.new
    user.first_name = Faker::Name.first_name
    user.last_name = Faker::Name.last_name
    user.email = user.first_name + "." + user.last_name + "@test.com"
    user.location = Faker::Address.city
    user.fb_uid = "1234345"
    user.fb_nickname = user.first_name + user.last_name.slice(0)
    user.fb_avatar_url = "http://i.imgur.com/emy2g.jpg"
    user.fb_oauth = 'test'
    user.fb_oauth_expires_at = 'test'
    response = user.get_card_token({:uri => "/v1/marketplaces/TEST-MPv0uxteFANO0h9xY5c6Lrq/cards",
                                           :name => user.first_name,
                                           :email => user.email,
                                           :card_number => "4111111111111111",
                                           :expiration_month => "10",
                                           :expiration_year => "2020"}).attributes["uri"]
    user.balanced_customer_uri = user.get_customer_token(response)
    puts "saved" if user.save
  end
end

def create_projects(num)
  num.times do |i|
    Project.create(owner: User.find(i + 1),
                   title: Faker::Company.catch_phrase,
                   description: Faker::Lorem.sentence(5),
                   hour_goal: 100,
                   dollar_goal: 200,
                   deadline: DateTime.now + rand(15..40))
  end
end

def create_current_projects(num)
  num.times do |i|
    Project.create(owner: User.find(i + 1),
                   title: Faker::Company.catch_phrase,
                   description: Faker::Lorem.sentence(5),
                   hour_goal: 100,
                   dollar_goal: 200,
                   deadline: DateTime.now.midnight)
  end
end

def create_donations(per_user)
  User.all.each do |user|
    Project.all.sample(per_user).each do |project|
      user.donations.create(project: project,
                            hours: 5,
                            dollar_amount: 10)
    end
  end
end

create_users(25)
create_projects(20)
create_current_projects(10)
create_donations(10)
