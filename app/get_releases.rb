token = ENV["DISCOGS_TOKEN"]
res = HTTParty.get("https://api.discogs.com/artists/2274799/releases?token=#{token}")
releases = JSON.parse(res.body)
releases.deep_symbolize_keys!
releases[:releases].map { |r| r.slice(:id, :title, :year) }
releases.each { |r| r[:release_id] = r.delete(:id) }
artist.releases.create(releases)
