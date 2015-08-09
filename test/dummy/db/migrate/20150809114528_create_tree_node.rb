class CreateTreeNode < ActiveRecord::Migration
  def change
    create_table :tree_nodes do |t|
      t.ltree :path
    end
  end
end
