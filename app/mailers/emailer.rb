class Emailer < ApplicationMailer
	def registration_email(user)
    @user = user
    mail(to: @user.email, subject: 'Welcome to Me Oi')
  end
end
