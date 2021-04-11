class AddArtistIdToReleases < ActiveRecord::Migration[5.2]
  def change
    add_reference :releases, :artist
  end
end
