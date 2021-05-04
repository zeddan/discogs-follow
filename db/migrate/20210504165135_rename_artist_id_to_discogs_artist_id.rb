class RenameArtistIdToDiscogsArtistId < ActiveRecord::Migration[5.2]
  def change
    rename_column :artists, :artist_id, :discogs_artist_id
  end
end
