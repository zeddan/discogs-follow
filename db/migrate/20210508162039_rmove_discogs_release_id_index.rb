class RmoveDiscogsReleaseIdIndex < ActiveRecord::Migration[5.2]
  def change
    remove_index :releases, :discogs_release_id
  end
end
