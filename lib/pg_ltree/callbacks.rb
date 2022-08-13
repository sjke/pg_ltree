module PgLtree
  module Callbacks
    extend ActiveSupport::Concern

    included do
      after_commit :cascade_update, on: :update, if: -> { ltree_option_for :cascade_update }
      after_commit :cascade_destroy, on: :destroy, if: -> { ltree_option_for :cascade_destroy }

      # Update child nodes path
      #
      # @return [ActiveRecord::Relation]
      def cascade_update
        ltree_scope
          .where(["#{self.class.table_name}.#{ltree_path_column} <@ ?", ltree_path_before_last_save])
          .where(["#{self.class.table_name}.#{ltree_path_column} != ?", ltree_path])
          .update_all ["#{ltree_path_column} = ? || subpath(#{ltree_path_column}, nlevel(?))", ltree_path, ltree_path_before_last_save]
      end

      # Destroy child nodes
      #
      # @return [ActiveRecord::Relation]
      def cascade_destroy
        ltree_scope.where("#{self.class.table_name}.#{ltree_path_column} <@ ?", ltree_path_in_database).destroy_all
      end
    end
  end
end
