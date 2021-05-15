class RemoveReleaseDate < ActiveRecord::Migration[5.2]
  def change
    remove_column :releases, :release_date
  end
end
