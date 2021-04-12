class ArtistWorker
  include Sidekiq::Worker

  def perform
    Artist.all.each do |artist|
      NewReleasesWorker.perform_async(artist.artist_id)
    end
  end
end
