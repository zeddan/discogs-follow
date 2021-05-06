require "rails_helper"

RSpec.describe Follow, type: :model do
  describe "relations" do
    it "can be an artist follow" do
      artist = create(:artist)
      follow = Follow.new(followable: artist)

      expect(follow.followable).to eq(artist)
    end

    it "can be a label follow" do
      label = create(:label)
      follow = Follow.new(followable: label)

      expect(follow.followable).to eq(label)
    end

    it "can be connected to a user" do
      user = create(:user)
      follow = Follow.new(user: user)

      expect(follow.user).to eq(user)
    end
  end
end
