class NewReleasesHandler
  def call
    token = ENV["DISCOGS_TOKEN"]
    res = HTTParty.get("https://api.discogs.com/artists/2274799/releases?token=#{token}")
    JSON.parse(res.body)
  end
end