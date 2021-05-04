require "rails_helper"

RSpec.describe ReleasesDownloader do
  subject(:call) { described_class.new(artist.discogs_artist_id).call }

  let(:discogs_url) { "https://api.discogs.com/artists/#{artist.discogs_artist_id}/releases?token=#{token}" }
  let(:token) { Rails.application.credentials.discogs_token }

  let(:api_response) { File.read("spec/fixtures/artist_releases.json") }
  let(:releases) { JSON.parse(api_response)["releases"] }
  let(:request) { stub_request(:get, discogs_url).to_return(body: api_response) }

  let(:artist) do
    create(
      :artist,
      releases: [
        build(:release, discogs_release_id: releases.first["id"])
      ]
    )
  end

  describe "#call" do
    before { request }

    it "sends request to discogs" do
      call

      expect(request).to have_been_made
    end

    it "saves new releases in db" do
      expect { call }
        .to change(Release, :count)
        .by(releases.size - artist.releases.size)
    end
  end
end
