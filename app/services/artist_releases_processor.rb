class ArtistReleasesProcessor
  def initialize(discogs_artist_id)
    @discogs_artist_id = discogs_artist_id
  end

  def call
    save_releases
  end

  private

  def save_releases
    all_releases = Discogs::ArtistReleases.new(@discogs_artist_id).call
    return if all_releases.empty?

    releases = releases_by_latest_year(all_releases)
    releases.each do |release|
      fetched_release = Discogs::Release.new(release_id(release)).call
      labels = find_or_create_labels(fetched_release)

      labels.each do |label|
        new_release = Release.find_or_initialize_by(
          discogs_release_id: fetched_release["id"],
          label: label
        )

        new_release.update!(
          artist: artist,
          uri: fetched_release["uri"],
          title: release["title"],
          year: release["year"],
          thumb: release["thumb"]
        )
      end
    end
  end

  def releases_by_latest_year(releases)
    latest_year = releases.first["year"]
    releases
      .select { |r| r["year"] == latest_year }
      .reject { |r| release_exists?(r) }
  end

  def artist
    @artist ||= Artist.find_by(discogs_artist_id: @discogs_artist_id)
  end

  def release_exists?(release)
    Release.find_by(discogs_release_id: release_id(release)).present?
  end

  def release_id(release)
    release["main_release"] || release["id"]
  end

  def find_or_create_labels(release)
    LabelProcessor.new(release).call
  end
end
