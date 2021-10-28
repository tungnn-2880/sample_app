class ApplicationMailer < ActionMailer::Base
  default from: Settings.gmail.username
  layout "mailer"
end
