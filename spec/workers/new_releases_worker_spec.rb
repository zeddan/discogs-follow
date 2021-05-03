require "rails_helper"
require "sidekiq/testing"

RSpec.describe NewReleasesWorker, type: :worker do
  subject(:perform) { described_class.perform_async }

  describe "#perform" do
    it "runs the new releases handler" do
      perform

      # expect(ReleasesDownloader.new).to receive(:call)
    end
  end
end
