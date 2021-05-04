require "rails_helper"

RSpec.describe Release, type: :model do
  describe ".latest" do
    it "returns releases for artists created before today" do
      artist1 = create(:artist, created_at: 1.day.ago)
      artist2 = create(:artist, created_at: 1.day.ago)

      expected_amount = artist1.releases.size + artist2.releases.size
      expect(Release.latest.size).to eq(expected_amount)
    end

    it "skips releases for artists created today" do
      artist1 = create(:artist, created_at: 1.day.ago)
      _artist2 = create(:artist)

      expect(Release.latest.size).to eq(artist1.releases.size)
    end

    it "returns nothing when all artists are created today" do
      _artist1 = create(:artist)
      _artist2 = create(:artist)

      expect(Release.latest).to be_empty
    end
  end
end
