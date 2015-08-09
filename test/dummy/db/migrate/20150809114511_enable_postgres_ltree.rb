class EnablePostgresLtree < ActiveRecord::Migration
  def change
    reversible do |dir|
      dir.up do
        execute <<-SQL
          CREATE EXTENSION IF NOT EXISTS ltree;
        SQL
      end
      dir.down do
      end
    end
  end
end
