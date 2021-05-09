class AddReleaseDateToRelease < ActiveRecord::Migration[5.2]
  def change
    add_column :releases, :release_date, :string
  end
end
