FactoryBot.define do
  sequence(:discogs_label_id) do |n|
    @discogs_label_ids ||= (1..1000).to_a
    @discogs_label_ids[n]
  end

  factory :label do
    discogs_label_id { FactoryBot.generate(:discogs_label_id) }
    name { "Label Name" }
  end
end
