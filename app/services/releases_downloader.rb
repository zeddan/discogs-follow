class ReleasesDownloader
  def initialize(discogs_artist_id)
    @discogs_artist_id = discogs_artist_id
  end

  def call
    save_releases
  end

  private

  def save_releases
    artist = Artist.find_by(discogs_artist_id: @discogs_artist_id)

    releases.each do |fetched_release|
      release = Release.find_or_create_by(
        discogs_release_id: fetched_release["id"],
        artist_id: artist.id,
      )
      release.update(
        title: fetched_release["title"],
        year: fetched_release["year"],
        thumb: fetched_release["thumb"]
      )
    end
  end

  def releases
    call_api["releases"]
  end

  def call_api
    response = HTTParty.get(url)
    JSON.parse(response.body)
  end

  def credentials
    {
      key: Rails.application.credentials.discogs_key,
      secret: Rails.application.credentials.discogs_secret
    }
  end

  def url
    [
      "https://api.discogs.com/artists/#{@discogs_artist_id}/releases?",
      "key=#{credentials[:key]}&",
      "secret=#{credentials[:secret]}"
    ].join
  end
end
