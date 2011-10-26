class Mailer < ActionMailer::Base
  default from: "vincent.b@5emegauche.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.mailer.invitation.subject
  #
  def invitation(invitation, signup_url)
    @signup_url = signup_url
    mail(:to => invitation.recipient_email, :subject => "Invitation")
    invitation.update_attribute(:sent_at, Time.now)
  end
end
