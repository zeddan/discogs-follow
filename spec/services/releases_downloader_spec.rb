require "rails_helper"

RSpec.describe ReleasesDownloader do
  subject(:call) { described_class.new(artist.discogs_artist_id).call }

  #### url things
  let(:credentials) do
    {
      key: Rails.application.credentials.discogs_key,
      secret: Rails.application.credentials.discogs_secret
    }
  end
  let(:releases_url) do
    [
      "https://api.discogs.com/artists/#{artist.discogs_artist_id}/releases?",
      "key=#{credentials[:key]}&",
      "secret=#{credentials[:secret]}"
    ].join
  end
  let(:release_8003926_url) do
    [
      "https://api.discogs.com/releases/8003926?",
      "key=#{credentials[:key]}&",
      "secret=#{credentials[:secret]}"
    ].join
  end
  let(:release_15204435_url) do
    [
      "https://api.discogs.com/releases/15204435?",
      "key=#{credentials[:key]}&",
      "secret=#{credentials[:secret]}"
    ].join
  end
  #### -- url things

  #### fixtures
  let(:releases_response) { File.read("spec/fixtures/artist_releases.json") }
  let(:release_8003926_response) { File.read("spec/fixtures/release_8003926.json") }
  let(:release_15204435_response) { File.read("spec/fixtures/release_15204435.json") }
  #### -- fixtures

  #### request stubs
  let(:releases_request) do
    stub_request(:get, releases_url).to_return(body: releases_response)
  end
  let(:release_8003926_request) do
    stub_request(:get, release_8003926_url).to_return(body: release_8003926_response)
  end
  let(:release_15204435_request) do
    stub_request(:get, release_15204435_url).to_return(body: release_15204435_response)
  end
  #### -- request stubs

  #### models
  let(:artist) do
    create(
      :artist,
      releases: [
        build(
          :release,
          label_id: label.id,
          discogs_release_id: releases.first["id"],
          title: releases.first["title"],
          year: releases.first["year"],
          thumb: releases.first["thumb"]
        )
      ]
    )
  end
  let(:label) { create(:label) }
  let(:releases) { JSON.parse(releases_response)["releases"] }
  let(:fake_release) { releases.last }
  #### -- models


  describe "#call" do
    before do
      releases_request
      release_8003926_request
      release_15204435_request
    end

    it "requests releases from api" do
      call

      expect(releases_request).to have_been_made
    end

    it "fetches label from api when not found" do
      call

      expect(release_8003926_request).to have_been_made
    end

    it "retrieves label from db if already existing" do
      Label.create(discogs_label_id: 705679, name: "sewer sender")

      call

      expect(release_15204435_request).not_to have_been_made
    end

    it "saves new releases in db" do
      expect { call }
        .to change(Release, :count)
        .by(releases.size - artist.releases.size)
    end

    it "does not save as a new release when something changes" do
      Release.create(
        artist_id: artist.id,
        label_id: label.id,
        discogs_release_id: fake_release["id"],
        title: fake_release["title"],
        year: fake_release["year"],
        thumb: "totally unchanged thumb"
      )

      expect { call }
        .to change(Release, :count)
        .by(releases.size - artist.releases.size - 1)
    end

    it "updates release thumbnail when changed from api" do
      Release.create(
        artist_id: artist.id,
        label_id: label.id,
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
