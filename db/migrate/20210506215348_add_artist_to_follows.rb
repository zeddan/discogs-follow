class AddArtistToFollows < ActiveRecord::Migration[5.2]
  def change
    add_reference :follows, :artist, foreign_key: true
  end
end
