class AddLabelToFollows < ActiveRecord::Migration[5.2]
  def change
    add_reference :follows, :label, foreign_key: true
  end
end
