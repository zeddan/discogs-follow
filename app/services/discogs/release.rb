module Discogs
  class Release
    def initialize(release_id)
      @release_id = release_id
    end

    def call
      get_release
    end

    private

    def get_release
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
        "https://api.discogs.com/releases/#{@release_id}?",
        "key=#{credentials[:key]}&",
        "secret=#{credentials[:secret]}"
      ].join
    end
  end
end