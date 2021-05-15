module Discogs
  class ArtistReleases
    def initialize(discogs_artist_id)
      @discogs_artist_id = discogs_artist_id
    end

    def call
      get_releases
    end

    private

    def get_releases
      main_releases
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
        "per_page=100&",
        "sort=year&",
        "sort_order=desc&",
        "key=#{credentials[:key]}&",
        "secret=#{credentials[:secret]}"
      ].join
    end
  end
end