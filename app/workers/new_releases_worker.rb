class NewReleasesWorker
  include Sidekiq::Worker

  def perform
    Artist.all.each do |artist|
      ArtistWorker.perform_async(artist.discogs_artist_id)
    end
  end
end
