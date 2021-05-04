class AddThumbToReleases < ActiveRecord::Migration[5.2]
  def change
    add_column :releases, :thumb, :string
  end
end
