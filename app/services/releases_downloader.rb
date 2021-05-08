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

    main_releases.each do |fetched_release|
      labels = find_or_create_labels(fetched_release)

      labels.each do |label|
        release = Release.find_or_initialize_by(
          discogs_release_id: fetched_release["main_release"] || fetched_release["id"],
          label: label
        )

        release.update!(
          artist_id: artist.id,
          title: fetched_release["title"],
          year: fetched_release["year"],
          thumb: fetched_release["thumb"]
        )
      end
    end
  end

  def find_or_create_labels(release)
    case release["type"]
    when "release"
      LabelDownloader.new(release["id"]).call
    when "master"
      LabelDownloader.new(release["main_release"]).call
    end
  end

  def main_releases
    # filter out Remix and TrackAppearance etc, let's use main
    releases.select { |r| r["role"].casecmp("main").zero? }
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
