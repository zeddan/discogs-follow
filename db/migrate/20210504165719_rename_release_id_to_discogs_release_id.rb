class RenameReleaseIdToDiscogsReleaseId < ActiveRecord::Migration[5.2]
  def change
    rename_column :releases, :release_id, :discogs_release_id
  end
end
