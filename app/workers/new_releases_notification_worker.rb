class NewReleasesNotificationWorker
  include Sidekiq::Worker

  def perform
    ReleasesMailer.notification.deliver_later unless Release.latest.none?
  end
end
