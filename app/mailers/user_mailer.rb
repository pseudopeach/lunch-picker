class UserMailer < ActionMailer::Base
  default from: "smgwilson37@gmail.com"

def invite_email(user)
  @user = user
  @url  = 'http://example.com/login'
  mail(to: @user, subject: 'Vote in the lunch election')
end

end
