module PgLtree
  module Model
    module Cascade
      extend ActiveSupport::Concern

      included do
        # Update all children for current path
        #
        # @return [Integer, nil]
        def cascade_update
          old_path = ltree_path_before_last_save
          new_path = ltree_path
          return if old_path.nil? || new_path.nil? || old_path == new_path

          ltree_scope
            .where(["#{ltree_qualified_column} <@ ?", old_path])
            .where(["#{ltree_qualified_column} != ?", new_path])
            .update_all(["#{ltree_quoted_column} = ? || subpath(#{ltree_quoted_column}, nlevel(?))", new_path, old_path])
        end

        # Delete all children for current path
        #
        # @return [Array, nil]
        def cascade_destroy
          db_path = ltree_path_in_database
          return if db_path.nil?

          ltree_scope.where(["#{ltree_qualified_column} <@ ?", db_path]).destroy_all
        end
      end
    end
  end
end
