class ReleasesDownloader
  def initialize(discogs_artist_id)
    @discogs_artist_id = discogs_artist_id
  end

  def call
    save_new_releases
  end

  private

  def save_new_releases
    artist = Artist.find_by(discogs_artist_id: @discogs_artist_id)

    releases.each do |release|
      artist.releases.find_or_create_by(
        discogs_release_id: release["id"],
        title: release["title"],
        year: release["year"],
      )
    end
  end

  def releases
    call_api["releases"]
  end

  def call_api
    token = Rails.application.credentials.discogs_token
    response = HTTParty.get("https://api.discogs.com/artists/#{@discogs_artist_id}/releases?token=#{token}")
    JSON.parse(response.body)
  end
end
