FactoryBot.define do
  sequence(:discogs_release_id) do |n|
    @discogs_release_ids ||= (1..1000).to_a
    @discogs_release_ids[n]
  end

  factory :release do
    discogs_release_id { FactoryBot.generate(:discogs_release_id) }
    title { "Dancing Memory" }
    year { 2013 }
  end
end
