class NewReleasesWorker
  include Sidekiq::Worker

  def perform(artist_id)
    NewReleasesHandler.new(artist_id).call
  end
end
