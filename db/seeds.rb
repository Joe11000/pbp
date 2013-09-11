require 'active_support/all'

WebMock.allow_net_connect!

def create_users(num)

  num.times do |i|
    user = User.new
    user.first_name = Faker::Name.first_name
    user.last_name = Faker::Name.last_name
    user.email = user.first_name + "." + user.last_name + "@test.com"
    user.location = Faker::Address.city
    user.nickname = user.first_name + user.last_name.slice(0)
    user.password = "password"
    user.password_confirmation = "password"
    user.avatar = "http://cdn.dashburst.com/wp-content/uploads/2013/04/tired-cat-on-dogs-head.jpg"
    user.method_of_contact = ["email", "twitter"].sample

    user.fb_uid = "1234345"
    user.fb_nickname = user.nickname + "fb"
    user.fb_avatar_url = "http://i.imgur.com/emy2g.jpg"
    user.fb_oauth = 'test'
    user.fb_oauth_expires_at = 'test'

    user.twitter_uid = "12345"
    user.twitter_nickname = user.nickname + "twitter"
    user.twitter_avatar_url = "http://i.imgur.com/emy2g.jpg"
    user.twitter_key = "1234"
    user.twitter_secret = "1234"

    user.set_customer_token(user.get_card_token)
    puts "User #{i} saved." if user.save
  end
end

def create_projects(num, deadline = DateTime.now + rand(15..40))
  User.all.sample(num).each do |user|
    project = user
      .created_projects
      .create(
        title: Faker::Company.catch_phrase,
        description: create_description,
        hour_goal: 100,
        dollar_goal: 20000,
        deadline: deadline)
    project.strip_media
    puts "Project #{project.title} created."
  end
end

def create_donations(per_user)
  User.all.each do |user|
    Project.all.sample(per_user).each do |project|
      donation = user
        .donations
        .create(project: project,
                hours: 5,
                dollar_amount: 1500)
      puts "#{user.nickname} donated to #{project.title}."
    end
  end
end

def create_description
  videos = [
    '<iframe width="420" height="315" src="//www.youtube.com/embed/V_53FZBTuxk" frameborder="0" allowfullscreen></iframe>',
    '<iframe width="560" height="315" src="//www.youtube.com/embed/Fj73JF_bhjc" frameborder="0" allowfullscreen></iframe>',
    '<iframe width="560" height="315" src="//www.youtube.com/embed/dvMssEgp1ko" frameborder="0" allowfullscreen></iframe>',
    '<iframe width="560" height="315" src="//www.youtube.com/embed/D36JUfE1oYk" frameborder="0" allowfullscreen></iframe>'
  ]

  photos = [
    '![alt](http://i.imgur.com/emy2g.jpg)',
    '![alt](http://wac.450f.edgecastcdn.net/80450F/q961.com/files/2013/03/cat-1-630x530.png)',
    '![alt](http://blu.stb.s-msn.com/i/C5/E33F1858618AE9D51E23BDCEB61E4_h316_w628_m5_cuPfPCagU.jpg)',
    '![alt](http://i.imgur.com/skSpO.jpg)'
  ]

  description = "# #{Faker::Lorem.sentence}" + "\n\n"
  description += videos.sample + "\n\n"
  description += photos.sample + "\n\n"
  description += Faker::Lorem.sentences(5).join(" ")
end

create_users(20)
create_projects(10)
create_projects(5, DateTime.now.midnight)
create_donations(10)
