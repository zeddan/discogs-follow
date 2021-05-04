class ArtistWorker
  include Sidekiq::Worker

  def perform(artist_id)
    Rails.logger.info("ArtistWorker: Downloading releases for artist_id=#{artist_id}")
    ReleasesDownloader.new(artist_id).call
  end
end
