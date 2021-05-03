class ReleasesMailer < ApplicationMailer
  def releases_notification
    mail(
      to: Rails.application.credentials.gmail_username,
      subject: "Test mail",
    )
  end
end
