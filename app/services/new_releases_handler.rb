class NewReleasesHandler
  ARTIST_ID = "2274799"

  def call
    save_new_releases
  end

  private

  def save_new_releases
    artist = Artist.find_by(artist_id: ARTIST_ID)

    releases.each do |release|
      artist.releases.find_or_create_by(
        release_id: release["id"],
        title: release["title"],
        year: release["year"]
      )
    end
  end

  def releases
    call_api["releases"]
  end

  def call_api
    token = ENV["DISCOGS_TOKEN"]
    response = HTTParty.get("https://api.discogs.com/artists/#{ARTIST_ID}/releases?token=#{token}")
    JSON.parse(response.body)
  end
end
