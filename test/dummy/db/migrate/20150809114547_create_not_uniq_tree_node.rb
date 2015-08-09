class CreateNotUniqTreeNode < ActiveRecord::Migration
  def change
    create_table :not_uniq_tree_nodes do |t|
      t.string :status
      t.ltree :new_path
    end
  end
end
