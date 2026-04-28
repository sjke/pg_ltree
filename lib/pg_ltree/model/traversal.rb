module PgLtree
  module Model
    module Traversal
      extend ActiveSupport::Concern

      included do
        # Get root of the node
        #
        # return [Object] root node
        def root
          ltree_scope.where(["#{self.class.table_name}.#{ltree_path_column} = SUBPATH(?, 0, 1)", ltree_path]).first
        end

        # Get parent of the node
        #
        # return [Object] root node
        def parent
          ltree_scope.find_by(["#{self.class.table_name}.#{ltree_path_column} = SUBPATH(?, 0, NLEVEL(?) - 1)", ltree_path, ltree_path])
        end

        # Get leaves of the node
        #
        # @return [ActiveRecord::Relation]
        def leaves
          ltree_scope.leaves.where(["#{self.class.table_name}.#{ltree_path_column} <@ ?", ltree_path]).where.not(ltree_path_column => ltree_path)
        end

        # Get self and ancestors
        #
        # @return [ActiveRecord::Relation]
        def self_and_ancestors
          ltree_scope.where(["#{self.class.table_name}.#{ltree_path_column} @> ?", ltree_path])
        end

        # Get ancestors
        #
        # @return [ActiveRecord::Relation]
        def ancestors
          self_and_ancestors.where.not ltree_path_column => ltree_path
        end

        # Get self and descendants
        #
        # @return [ActiveRecord::Relation]
        def self_and_descendants
          ltree_scope.where(["#{self.class.table_name}.#{ltree_path_column} <@ ?", ltree_path])
        end

        # Get descendants
        #
        # @return [ActiveRecord::Relation]
        def descendants
          self_and_descendants.where.not ltree_path_column => ltree_path
        end

        # Get self and siblings
        #
        # @return [ActiveRecord::Relation]
        def self_and_siblings
          ltree_scope.where(
            ["SUBPATH(?, 0, NLEVEL(?) - 1) @> #{self.class.table_name}.#{ltree_path_column} AND nlevel(#{self.class.table_name}.#{ltree_path_column}) = NLEVEL(?)",
            ltree_path, ltree_path, ltree_path]
          )
        end

        # Get siblings
        #
        # @return [ActiveRecord::Relation]
        def siblings
          self_and_siblings.where.not ltree_path_column => ltree_path
        end

        # Get children
        #
        # @return [ActiveRecord::Relation]
        def children
          ltree_scope.where(["? @> #{self.class.table_name}.#{ltree_path_column} AND nlevel(#{self.class.table_name}.#{ltree_path_column}) = NLEVEL(?) + 1", ltree_path, ltree_path])
        end
      end
    end
  end
end
