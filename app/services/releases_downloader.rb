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
      release = Discogs::Release.new(release_id(fetched_release)).call
      labels = find_or_create_labels(release)

      labels.each do |label|
        new_release = Release.find_or_initialize_by(
          discogs_release_id: fetched_release["main_release"] || fetched_release["id"],
          label: label
        )

        new_release.update!(
          artist_id: artist.id,
          uri: release["uri"],
          title: fetched_release["title"],
          year: fetched_release["year"],
          thumb: fetched_release["thumb"]
        )
      end
    end
  end

  def release_id(release)
    case release["type"]
    when "release"
      release["id"]
    when "master"
      release["main_release"]
    end
  end

  def find_or_create_labels(release)
    LabelProcessor.new(release).call
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
