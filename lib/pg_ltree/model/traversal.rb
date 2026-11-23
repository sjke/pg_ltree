module PgLtree
  module Model
    module Traversal
      extend ActiveSupport::Concern

      included do
        # Get root of the node
        #
        # @return [Object, nil] root node
        def root
          return nil if ltree_path.nil?

          ltree_scope.where(["#{ltree_qualified_column} = SUBPATH(?, 0, 1)", ltree_path]).first
        end

        # Get parent of the node
        #
        # @return [Object, nil] parent node
        def parent
          return nil if ltree_path.nil? || root?

          ltree_scope.find_by(["#{ltree_qualified_column} = SUBPATH(?, 0, NLEVEL(?) - 1)", ltree_path, ltree_path])
        end

        # Get leaves of the node
        #
        # @return [ActiveRecord::Relation]
        def leaves
          ltree_scope.leaves.where(["#{ltree_qualified_column} <@ ?", ltree_path]).where.not(ltree_path_column => ltree_path)
        end

        # Get self and ancestors
        #
        # @return [ActiveRecord::Relation]
        def self_and_ancestors
          ltree_scope.where(["#{ltree_qualified_column} @> ?", ltree_path])
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
          ltree_scope.where(["#{ltree_qualified_column} <@ ?", ltree_path])
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
            [
              "SUBPATH(?, 0, NLEVEL(?) - 1) @> #{ltree_qualified_column} AND nlevel(#{ltree_qualified_column}) = NLEVEL(?)",
              ltree_path, ltree_path, ltree_path
            ]
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
          ltree_scope.where(["? @> #{ltree_qualified_column} AND nlevel(#{ltree_qualified_column}) = NLEVEL(?) + 1", ltree_path, ltree_path])
        end
      end
    end
  end
end
