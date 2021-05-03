require "rails_helper"

RSpec.describe ReleasesDownloader do
  subject(:call) { described_class.new(artist.artist_id).call }

  let(:discogs_url) { "https://api.discogs.com/artists/#{artist.artist_id}/releases?token=#{token}" }
  let(:token) { Rails.application.credentials.discogs_token }

  let(:api_response) { File.read("spec/fixtures/artist_releases.json") }
  let(:releases) { JSON.parse(api_response)["releases"] }
  let(:request) { stub_request(:get, discogs_url).to_return(body: api_response) }

  let(:artist) { create(:artist) }

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
