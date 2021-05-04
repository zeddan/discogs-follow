FactoryBot.define do
  sequence(:artist_id) do |n|
    @artist_ids ||= (1..1000).to_a
    @artist_ids[n]
  end

  factory :artist do
    name { "Artist 1" }
    artist_id { FactoryBot.generate(:artist_id) }
    releases { [build(:release)] }
  end
end
