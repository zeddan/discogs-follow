class NewReleasesWorker
  include Sidekiq::Worker

  def perform
    Artist.all.each do |artist|
      ArtistWorker.perform_async(artist.artist_id)
    end
  end
end
