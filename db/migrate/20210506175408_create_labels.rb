class CreateLabels < ActiveRecord::Migration[5.2]
  def change
    create_table :labels do |t|
      t.integer :discogs_label_id, index: { unique: true }
      t.string :name

      t.timestamps
    end
  end
end
