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
    fetched_release = releases.max_by { |release| release["year"] }
    release = Discogs::Release.new(release_id(fetched_release)).call
    labels = find_or_create_labels(release)

    labels.each do |label|
      new_release = Release.find_or_initialize_by(
        discogs_release_id: release_id(release),
        label: label
      )

      new_release.update!(
        artist: artist,
        uri: release["uri"],
        title: fetched_release["title"],
        year: fetched_release["year"],
        thumb: fetched_release["thumb"]
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
