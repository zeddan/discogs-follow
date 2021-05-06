require "rails_helper"

RSpec.describe ReleasesDownloader do
  subject(:call) { described_class.new(artist.discogs_artist_id).call }

  let(:credentials) do
    {
      key: Rails.application.credentials.discogs_key,
      secret: Rails.application.credentials.discogs_secret
    }
  end

  let(:discogs_url) do
    [
      "https://api.discogs.com/artists/#{artist.discogs_artist_id}/releases?",
      "key=#{credentials[:key]}&",
      "secret=#{credentials[:secret]}"
    ].join
  end

  let(:api_response) { File.read("spec/fixtures/artist_releases.json") }
  let(:releases) { JSON.parse(api_response)["releases"] }
  let(:fake_release) { releases.last }
  let(:request) { stub_request(:get, discogs_url).to_return(body: api_response) }

  let(:artist) do
    create(
      :artist,
      releases: [
        build(
          :release,
          discogs_release_id: releases.first["id"],
          title: releases.first["title"],
          year: releases.first["year"],
          thumb: releases.first["thumb"]
        )
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

    it "does not save as a new release when something changes" do
      Release.create(
        artist_id: artist.id,
        discogs_release_id: fake_release["id"],
        title: fake_release["title"],
        year: fake_release["year"],
        thumb: "totally unchanged thumb"
      )

      expect { call }
        .to change(Release, :count)
        .by(releases.size - artist.releases.size - 1)
    end

    it "updates release thumbnail when changed from api", run: true do
      Release.create(
        artist_id: artist.id,
        discogs_release_id: fake_release["id"],
        title: fake_release["title"],
        year: fake_release["year"],
        thumb: "should be changed"
      )

      call

      updated_release = artist.releases.find_by(discogs_release_id: fake_release["id"])
      expect(updated_release.thumb).to eq(fake_release["thumb"])
    end

    it "saves discogs release id" do
      call

      saved_release = Release.find_by(discogs_release_id: fake_release["id"])
      expect(saved_release).to be_present
    end

    it "saves title" do
      call

      saved_release = Release.find_by(discogs_release_id: fake_release["id"])
      expect(saved_release.title).to eq(fake_release["title"])
    end

    it "saves release year" do
      call

      saved_release = Release.find_by(discogs_release_id: fake_release["id"])
      expect(saved_release.year).to eq(fake_release["year"])
    end

    it "saves thumbnail image" do
      call

      saved_release = Release.find_by(discogs_release_id: fake_release["id"])
      expect(saved_release.thumb).to eq(fake_release["thumb"])
    end
  end
end
