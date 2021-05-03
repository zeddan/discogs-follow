class ReleasesMailer < ApplicationMailer
  def notification
    @releases = Release.latest
    mail(
      to: Rails.application.credentials.me,
      subject: "New releases!",
    )
  end
end
