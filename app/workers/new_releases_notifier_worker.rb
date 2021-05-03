class NewReleasesNotifierWorker
  include Sidekiq::Worker

  def perform(*args)
    new_releases = Release.today
  end
end
