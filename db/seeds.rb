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
    user.save
  end
end

def create_projects(num)
  num.times do |i|
    Project.create(owner: User.find(i + 1),
                   title: Faker::Company.catch_phrase,
                   description: Faker::Lorem.sentence(5),
                   hour_goal: rand(50..200),
                   dollar_goal: rand(100..1000),
                   deadline: DateTime.now + rand(15..40))
  end
end

def create_donations(per_user)
  User.all.each do |user|
    Project.all.sample(5).each do |project|
      user.donations.create(project: project,
                            hours: rand(10..50),
                            dollar_amount: rand(10..500))
    end
  end
end

create_users(50)
create_projects(10)
create_donations(5)
