FactoryBot.define do
  factory :artist do
    name { "Artist 1" }
    artist_id { 2274799 }
    releases { [build(:release)] }
  end
end
