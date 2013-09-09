class UserMailer < ActionMailer::Base
  layout 'mailer'
  default :css => 'email', from: 'notifications@parkbenchprojects.com'

  def welcome_email(user)
    @user = user
    @title = "Welcome to Park Bench Projects"
    @message = "Hey, #{@user.first_name} We're glad you have signed up with Park Bench Projects.  This is going to be awesome."
    mail(to: @user.email, subject: 'Welcome to Park Bench Projects')
  end
end
