module PgLtree
  module Model
    module Cascade
      extend ActiveSupport::Concern

      included do
        # Update all childen for current path
        #
        # @return [ActiveRecord::Relation]
        def cascade_update
          ltree_scope
            .where(["#{self.class.table_name}.#{ltree_path_column} <@ ?", ltree_path_before_last_save])
            .where(["#{self.class.table_name}.#{ltree_path_column} != ?", ltree_path])
            .update_all(["#{ltree_path_column} = ? || subpath(#{ltree_path_column}, nlevel(?))", ltree_path, ltree_path_before_last_save])
        end

        # Delete all children for current path
        #
        # @return [ActiveRecord::Relation]
        def cascade_destroy
          ltree_scope.where("#{self.class.table_name}.#{ltree_path_column} <@ ?", ltree_path_in_database).destroy_all
        end
      end
    end
  end
end
