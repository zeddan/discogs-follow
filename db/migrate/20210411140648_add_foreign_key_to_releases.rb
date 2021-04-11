class AddForeignKeyToReleases < ActiveRecord::Migration[5.2]
  def change
    add_foreign_key :releases, :artists
  end
end
