class ReleasesDownloader
  def initialize(artist_id)
    @artist_id = artist_id
  end

  def call
    save_new_releases
  end

  private

  def save_new_releases
    artist = Artist.find_by(artist_id: @artist_id)

    releases.each do |release|
      artist.releases.find_or_create_by(
        release_id: release["id"],
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
    response = HTTParty.get("https://api.discogs.com/artists/#{@artist_id}/releases?token=#{token}")
    JSON.parse(response.body)
  end
end
