FactoryBot.define do
  sequence(:release_id) do |n|
    @release_ids ||= (1..1000).to_a
    @release_ids[n]
  end

  factory :release do
    release_id { FactoryBot.generate(:release_id) }
    title { "Dancing Memory" }
    year { 2013 }
  end
end
