class NewReleasesWorker
  include Sidekiq::Worker

  def perform
    puts "YO"
    # NewReleasesHandler.new.call
  end
end
