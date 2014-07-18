class UserMailer < ActionMailer::Base
  default from: "smgwilson37@gmail.com"

def invite_email(user)
  @user = user
  @admin_email = 'smgwilson37@gmail.com' #TODO - fix temporary hard-coding
  @url  = 'http://example.com/login'
  mail(to: @user, subject: 'Vote in the lunch election')
end

end
