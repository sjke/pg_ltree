module PgLtree
  module Model
    module Querying
      extend ActiveSupport::Concern

      class_methods do
        def ltree_path_column
          ltree_option_for :column
        end

        # Get roots
        #
        # @return [ActiveRecord::Relation] relations of node's roots
        def roots
          at_depth 1
        end

        # Get nodes on the level
        #
        # @param depth [Integer] Depth of the nodes
        # @return [ActiveRecord::Relation] relations of nodes for the depth
        def at_depth(depth)
          where(["NLEVEL(#{table_name}.#{ltree_path_column}) = ?", depth])
        end

        # Get all leaves
        #
        # @return [ActiveRecord::Relation] relations of node's leaves
        def leaves
          subquery = unscoped.select("#{table_name}.#{ltree_path_column}")
            .from("#{table_name} AS subquery")
            .where("#{table_name}.#{ltree_path_column} <> subquery.#{ltree_path_column}")
            .where("#{table_name}.#{ltree_path_column} @> subquery.#{ltree_path_column}")

          where.not ltree_path_column => subquery
        end

        # Get all with nodes when path liked the lquery
        #
        # @param lquery [String] ltree query
        # @return [ActiveRecord::Relation] relations of node'
        def where_path_liked(lquery)
          where(["#{table_name}.#{ltree_path_column} ~ ?", lquery])
        end

        # Get all nodes with path matching full-text-search-like pattern
        #
        # @param ltxtquery [String] ltree search query
        # @return [ActiveRecord::Relation] of matching nodes
        def where_path_matches_ltxtquery(ltxtquery)
          where(["#{table_name}.#{ltree_path_column} @ ?", ltxtquery])
        end
      end
    end
  end
end
