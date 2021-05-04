class AddIndexToArtists < ActiveRecord::Migration[5.2]
  def change
    add_index :artists, :discogs_artist_id, unique: true
  end
end
