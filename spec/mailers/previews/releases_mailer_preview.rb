# Preview all emails at http://localhost:3000/rails/mailers/releases_mailer
class ReleasesMailerPreview < ActionMailer::Preview
  def notification
    ReleasesMailer.notification
  end
end
