# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

create_users(50)
create_projects(10)
create_donations(5)

def create_users(num)
  num.times do
    first = Faker::Name.firstname
    last = Faker::Name.lastname
    User.create(name: first + " " + last,
                email: first + "." + last "@test.com")
  end
end

def create_projects(num)
  num.times do |i|
    Project.create(owner: User.find(i),
                   title: Faker::Company.catchphrase,
                   description: Faker::Lorem.sentence(5),
                   hour_goal: rand(50..200),
                   dollar_goal: rand(100..1000))
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
