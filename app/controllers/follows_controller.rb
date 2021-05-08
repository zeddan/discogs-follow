# frozen_string_literal: true

class FollowsController < ApplicationController
  before_action :set_follow, only: %i[destroy]

  def create
    follow = Follow.new(followable: @followable, user: current_user)
    respond_to do |format|
      if follow.save!
        download_discogs_data(follow)
        format.html do
          redirect_to root_url,
                      notice: "you are now following #{follow.followable.name}"
        end
      else
        format.html { render :new }
      end
    end
  end

  def destroy
    name = @follow.followable.name
    @follow.destroy!
    respond_to do |format|
      format.html do
        redirect_to root_url,
                    notice: "you are no longer following #{name}"
      end
    end
  end

  private

  def set_follow
    @follow = Follow.find(params[:id])
  end

  def download_discogs_data(follow)
    case @followable
    when Artist
      ArtistWorker.perform_async(follow.followable.discogs_artist_id)
    when Label
      # this worker does not exist yet
      LabelWorker.perform_async(follow.followable.discogs_label_id)
    end
  end
end
