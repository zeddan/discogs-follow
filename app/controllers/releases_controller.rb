# frozen_string_literal: true

class ReleasesController < ApplicationController
  def index
    @releases = Release.all.sort_by(&:year).reverse!
  end
end
