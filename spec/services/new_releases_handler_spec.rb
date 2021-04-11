require "rails_helper"

RSpec.describe NewReleasesHandler do
  subject(:call) { described_class.new.call }

  let(:discogs_url) { "https://api.discogs.com/artists/#{artist_id}/releases?token=#{token}" }
  let(:token) { ENV["DISCOGS_TOKEN"] }
  let(:artist_id) { "2274799" }

  let(:artist_releases) { File.read('spec/fixtures/artist_releases.json') }
  let(:request) { stub_request(:get, discogs_url).to_return(body: artist_releases) }

  describe '#call' do
    before { request }

    it "sends request to discogs" do
      call

      expect(request).to have_been_made
    end

    it "returns all artist releases" do
      response = call

      expect(response).to eq(JSON.parse(artist_releases))
    end
  end
end
