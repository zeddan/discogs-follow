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
      release = Release.find_or_initialize_by(
        discogs_release_id: fetched_release["id"]
      )

      release.update!(
        label: find_or_create_label(
          name: fetched_release["label"],
          release_id: fetched_release["id"],
        ),
        artist_id: artist.id,
        title: fetched_release["title"],
        year: fetched_release["year"],
        thumb: fetched_release["thumb"]
      )
    end
  end

  def find_or_create_label(name:, release_id:)
    Label.find_by(name: name) || LabelDownloader.new(name, release_id).call
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
