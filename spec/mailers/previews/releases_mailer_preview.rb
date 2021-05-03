# Preview all emails at http://localhost:3000/rails/mailers/releases_mailer
class ReleasesMailerPreview < ActionMailer::Preview
  def releases_notification
    ReleasesMailer.releases_notification
  end
end
