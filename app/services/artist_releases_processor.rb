class ArtistReleasesProcessor
  def initialize(discogs_artist_id)
    @discogs_artist_id = discogs_artist_id
  end

  def call
    save_releases
  end

  private

  def save_releases
    releases = Discogs::ArtistReleases.new(@discogs_artist_id).call
    return if releases.empty?

    latest_release_year = releases.first["year"]
    latest_year_releases = releases.select { |r| r["year"] == latest_release_year }

    latest_release_detailed = latest_year_releases.map do |release|
      Discogs::Release.new(release_id(release)).call
    end.max_by do |release|
      release["released"]
    end

    latest_release_general = latest_year_releases.detect do |release|
      release_id(release) == latest_release_detailed["id"]
    end

    labels = find_or_create_labels(latest_release_detailed)

    labels.each do |label|
      new_release = Release.find_or_initialize_by(
        discogs_release_id: latest_release_detailed["id"],
        label: label
      )

      new_release.update!(
        artist: artist,
        release_date: latest_release_detailed["released"],
        uri: latest_release_detailed["uri"],
        title: latest_release_general["title"],
        year: latest_release_general["year"],
        thumb: latest_release_general["thumb"]
      )
    end
  end

  def artist
    Artist.find_by(discogs_artist_id: @discogs_artist_id)
  end

  def release_id(release)
    release["main_release"] || release["id"]
  end

  def find_or_create_labels(release)
    LabelProcessor.new(release).call
  end
end
