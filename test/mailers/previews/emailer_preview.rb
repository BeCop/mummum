# Preview all emails at http://localhost:3000/rails/mailers/emailer
class EmailerPreview < ActionMailer::Preview
  def registration_mail_preview
    Emailer.registration_email(User.first)
  end
end
