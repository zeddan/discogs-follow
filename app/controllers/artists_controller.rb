# frozen_string_literal: true

class ArtistsController < ApplicationController
  before_action :set_artist, only: %i[edit update destroy]

  def index
    @artists = Artist.all
  end

  def new
    @artist = Artist.new
  end

  def edit; end

  def show; end

  def create
    @artist = Artist.new(artist_params)

    respond_to do |format|
      if @artist.save
        ArtistWorker.perform_async(@artist.discogs_artist_id)
        format.html { redirect_to artists_url, notice: "you are now following #{@artist.name}" }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @artist.update(artist_params)
        format.html { redirect_to artists_url, notice: "#{@artist.name} was successfully updated" }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @artist.destroy
    respond_to do |format|
      format.html { redirect_to artists_url, notice: "you are no longer following #{@artist.name}" }
    end
  end

  private

  def set_artist
    @artist = Artist.find(params[:id])
  end

  def artist_params
    params.require(:artist).permit(:name, :discogs_artist_id)
  end
end
