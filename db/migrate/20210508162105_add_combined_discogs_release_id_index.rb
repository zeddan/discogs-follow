class AddCombinedDiscogsReleaseIdIndex < ActiveRecord::Migration[5.2]
  def change
    add_index :releases, %i[discogs_release_id label_id], unique: true
  end
end
