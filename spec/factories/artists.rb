FactoryBot.define do
  sequence(:discogs_artist_id) do |n|
    @discogs_artist_ids ||= (1..1000).to_a
    @discogs_artist_ids[n]
  end

  factory :artist do
    name { "Artist 1" }
    discogs_artist_id { FactoryBot.generate(:discogs_artist_id) }
    releases { [build(:release)] }
  end
end
