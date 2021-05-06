require "rails_helper"

RSpec.describe User, type: :model do
  describe "relations" do
    it "can follow multiple things" do
      user = create(:user)
      follow1 = user.follows.new
      follow2 = user.follows.new

      expect(user.follows).to eq([follow1, follow2])
    end

    it "can follow many artists" do
      user = create(:user)
      artist1 = create(:artist)
      user.follows.create(followable: artist1)
      artist2 = create(:artist)
      user.follows.create(followable: artist2)

      expect(user.artists).to eq([artist1, artist2])
    end

    it "can follows many labels" do
      user = create(:user)
      label1 = create(:label)
      user.follows.create(followable: label1)
      label2 = create(:label)
      user.follows.create(followable: label2)

      expect(user.labels).to eq([label1, label2])
    end
  end
end
