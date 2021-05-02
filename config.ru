# This file is used by Rack-based servers to start the application.

require_relative "config/environment"

# map "/discogs-follow" do
#   run Rails.application
# end
run Rails.application
