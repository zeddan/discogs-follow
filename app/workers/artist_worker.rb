class ArtistWorker
  include Sidekiq::Worker

  def perform(discogs_artist_id)
    Rails.logger.info("ArtistWorker: Downloading releases for discogs_artist_id=#{discogs_artist_id}")
    ArtistReleasesProcessor.new(discogs_artist_id).call
  end
end
