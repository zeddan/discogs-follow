require "rails_helper"

RSpec.describe ArtistReleasesProcessor do
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
      "per_page=100&",
      "key=#{credentials[:key]}&",
      "secret=#{credentials[:secret]}"
    ].join
  end
  let(:release_8003926_url) do
    [
      "https://api.discogs.com/releases/8003926?",
      "per_page=100&",
      "key=#{credentials[:key]}&",
      "secret=#{credentials[:secret]}"
    ].join
  end
  let(:release_15204435_url) do
    [
      "https://api.discogs.com/releases/15204435?",
      "per_page=100&",
      "key=#{credentials[:key]}&",
      "secret=#{credentials[:secret]}"
    ].join
  end
  let(:release_18623872_url) do
    [
      "https://api.discogs.com/releases/18623872?",
      "per_page=100&",
      "key=#{credentials[:key]}&",
      "secret=#{credentials[:secret]}"
    ].join
  end
  #### -- url things

  #### fixtures
  let(:releases_response) { File.read("spec/fixtures/artist_releases.json") }
  let(:release_8003926_response) { File.read("spec/fixtures/release_8003926.json") }
  let(:release_15204435_response) { File.read("spec/fixtures/release_15204435.json") }
  let(:release_18623872_response) { File.read("spec/fixtures/release_18623872.json") }
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
  let(:release_18623872_request) do
    stub_request(:get, release_18623872_url).to_return(body: release_18623872_response)
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
          discogs_release_id: existing_release["id"],
          uri: existing_release_detail["uri"],
          title: existing_release["title"],
          year: existing_release["year"],
          thumb: existing_release["thumb"]
        )
      ]
    )
  end
  let(:label) { create(:label, discogs_label_id: 97715) }
  let(:releases) { JSON.parse(releases_response)["releases"] }
  let(:existing_release) { releases.detect { |r| r["id"] == 15204435 } }
  let(:existing_release_detail) { JSON.parse(release_15204435_response) }
  let(:latest_release) { releases.detect { |r| r["main_release"] == 18623872 } }
  let(:latest_release_detail) { JSON.parse(release_18623872_response) }
  #### -- models

  describe "#call" do
    before do
      releases_request
      release_8003926_request
      release_15204435_request
      release_18623872_request
    end

    it "requests the artist's releases from api" do
      call

      expect(releases_request).to have_been_made
    end

    it "requests single release from api" do
      call

      expect(release_18623872_request).to have_been_made
    end

    it "selects the latest release" do
      release_id = latest_release["main_release"] || latest_release["main_release"]

      call

      saved_release = Release.find_by(discogs_release_id: release_id)
      expect(saved_release).to be_present
    end

    it "does not fetch other releases than the latest" do
      expect { call }.to change(Release, :count).by(1)
    end

    it "does not save as a new release when something changes" do
      artist.releases.create(
        label_id: label.id,
        discogs_release_id: latest_release["main_release"],
        uri: latest_release_detail["uri"],
        title: latest_release["title"],
        year: latest_release["year"],
        thumb: "i will change"
      )

      expect { call }.to change(Release, :count).by(0)
    end

    it "updates release thumbnail when changed from api" do
      artist.releases.create(
        label_id: label.id,
        discogs_release_id: latest_release["main_release"],
        uri: latest_release_detail["uri"],
        title: latest_release["title"],
        year: latest_release["year"],
        thumb: "i will change"
      )

      call

      updated_release = artist.releases.find_by(discogs_release_id: latest_release["main_release"])
      expect(updated_release.thumb).to eq(latest_release["thumb"])
    end

    it "saves discogs release id" do
      call

      saved_release = Release.find_by(discogs_release_id: latest_release["main_release"])
      expect(saved_release).to be_present
    end

    it "saves title" do
      call

      saved_release = Release.find_by(discogs_release_id: latest_release["main_release"])
      expect(saved_release.title).to eq(latest_release["title"])
    end

    it "saves release year" do
      call

      saved_release = Release.find_by(discogs_release_id: latest_release["main_release"])
      expect(saved_release.year).to eq(latest_release["year"])
    end

    it "saves thumbnail image" do
      call

      saved_release = Release.find_by(discogs_release_id: latest_release["main_release"])
      expect(saved_release.thumb).to eq(latest_release["thumb"])
    end

    it "saves uri" do
      call

      saved_release = Release.find_by(discogs_release_id: latest_release["main_release"])
      expect(saved_release.uri).to eq(latest_release_detail["uri"])
    end
  end
end
