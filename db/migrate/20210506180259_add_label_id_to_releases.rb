class AddLabelIdToReleases < ActiveRecord::Migration[5.2]
  def change
    add_reference :releases, :label
  end
end
