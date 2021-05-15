# frozen_string_literal: true

class ArtistsController < ApplicationController
  before_action :set_artist, only: %i[show edit update destroy]

  def index
    @artists = Artist.all
  end

  def new
    @artist = Artist.new
  end

  def show; end

  def edit; end

  def update
    respond_to do |format|
      if @artist.update(artist_params)
        format.html { redirect_to root_path, notice: "#{@artist.name} was successfully updated" }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @artist.destroy
    respond_to do |format|
      format.html { redirect_to root_path, notice: "#{@artist.name} was successfully deleted" }
    end
  end

  private

  def set_artist
    @artist = Artist.find(params[:id])
  end

  def artist_params
    params.require(:artist).permit(:name)
  end
end
