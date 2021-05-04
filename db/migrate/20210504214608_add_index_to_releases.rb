class AddIndexToReleases < ActiveRecord::Migration[5.2]
  def change
    add_index :releases, :discogs_release_id, unique: true
  end
end
