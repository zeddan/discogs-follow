class AddUriToReleases < ActiveRecord::Migration[5.2]
  def change
    add_column :releases, :uri, :string
  end
end
