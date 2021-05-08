require "rails_helper"

RSpec.describe "Artists", type: :request do
  let(:artist) { create(:artist) }
  let(:user) { create(:user) }
  let(:session) { { email: user.email, password: user.password } }

  describe "POST /artists/:id/follows" do
    before do
      post "/login", params: { session: session }
      post "/artists/#{artist.id}/follows"
    end

    it "creates a new artist following" do
      follow = Follow.find_by(followable: artist, user: user)

      expect(follow).to be_present
    end
  end

  describe "DELETE /artists/:id/follows" do
    before do
      follow = Follow.create(followable: artist, user: user)
      post "/login", params: { session: session }
      delete "/artists/#{artist.id}/follows/#{follow.id}"
    end

    it "removes an artist following" do
      follow = Follow.find_by(followable: artist, user: user)

      expect(follow).to be_nil
    end

    it "does not remove the artist" do
      expect(Artist.find(artist.id)).to eq(artist)
    end

    it "does not remove the user" do
      expect(User.find(user.id)).to eq(user)
    end
  end
end
