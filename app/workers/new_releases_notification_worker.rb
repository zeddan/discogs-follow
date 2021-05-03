class NewReleasesNotificationWorker
  include Sidekiq::Worker

  def perform
    ReleasesMailer.notification.deliver_later
  end
end
