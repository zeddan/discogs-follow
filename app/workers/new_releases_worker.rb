class NewReleasesWorker
  include Sidekiq::Worker

  def perform(artist_id)
    ReleasesDownloader.new(artist_id).call
  end
end
