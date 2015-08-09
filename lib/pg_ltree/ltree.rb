module PgLtree
  # Implementatios Postgres ltree for ActiveRecord
  #
  # @see [ActiveRecord::Base]
  # @see http://www.postgresql.org/docs/current/static/ltree.html
  #
  # @author a.ponomarenko
  module Ltree

    # Initialzie ltree for active model
    #
    # @param column [String] ltree column name
    def ltree(column = :path)
      cattr_accessor :ltree_path_column

      self.ltree_path_column = column

      has_and_belongs_to_many column.to_s.tableize.to_sym,
            class_name: self.class.name,
            association_foreign_key: 'path'

      extend ClassMethods
      include InstanceMethods
    end

    # Define class methods
    module ClassMethods
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
        where "NLEVEL(#{ltree_path_column}) = ?", depth
      end

      # Get all leaves
      #
      # @return [ActiveRecord::Relation] relations of node's leaves
      def leaves
        subquery =
          select("COUNT(subquery.#{ltree_path_column}) = 1")
          .from("#{table_name} AS subquery")
          .where("subquery.#{ltree_path_column} <@ #{table_name}.#{ltree_path_column}").to_sql
        where subquery
      end

      # Get all with nodes when path liked the lquery
      #
      # @param lquery [String] ltree query
      # @return [ActiveRecord::Relation] relations of node'
      def where_path_liked(lquery)
        where "#{ltree_path_column} ~ ?", lquery
      end
    end

    # Define instance methods
    module InstanceMethods

      # Get default scope of ltree
      #
      # @return current class
      def ltree_scope
        self.class
      end

      # Get lTree column
      #
      # @return [String] ltree column name
      def ltree_path_column
        ltree_scope.ltree_path_column
      end

      # Get lTree value
      #
      # @return [String] ltree current value
      def ltree_path
        public_send ltree_path_column
      end

      # Get lTree previous value
      #
      # @return [String] ltree previous value
      def ltree_path_was
        public_send :"#{ltree_path_column}_was"
      end

      # Check what current node is root
      #
      # @return [Boolean] True - for root node, False - for childen node
      def root?
        depth == 1
      end

      # Get node depth
      #
      # @return [Integer] node depth
      def depth
        ltree_scope.distinct.pluck("NLEVEL('#{ltree_path}')").first || nil
      end

      # Get root of the node
      #
      # return [Object] root node
      def root
        ltree_scope.where("#{ltree_path_column} = SUBPATH(?, 0, 1)", ltree_path).first
      end

      # Get parent of the node
      #
      # return [Object] root node
      def parent
        ltree_scope.find_by "#{ltree_path_column} = SUBPATH(?, 0, NLEVEL(?) - 1)", ltree_path, ltree_path
      end

      # Get leaves of the node
      #
      # @return [ActiveRecord::Relation]
      def leaves
        ltree_scope.leaves.where("#{ltree_path_column} <@ ?", ltree_path).where.not ltree_path_column => ltree_path
      end

      # Check what current node have leaves
      #
      # @return [Boolean] True - if node have leaves, False - if node doesn't have leaves
      def leaf?
        leaves.count == 0
      end

      # Get self and ancestors
      #
      # @return [ActiveRecord::Relation]
      def self_and_ancestors
        ltree_scope.where("#{ltree_path_column} @> ?", ltree_path)
      end

      # Get ancestors
      #
      # @return [ActiveRecord::Relation]
      def ancestors
        self_and_ancestors.where.not ltree_path_column => ltree_path
      end

      # Get self and descendents
      #
      # @return [ActiveRecord::Relation]
      def self_and_descendents
        ltree_scope.where("#{ltree_path_column} <@ ?", ltree_path)
      end

      # Get descendents
      #
      # @return [ActiveRecord::Relation]
      def descendents
        self_and_descendents.where.not ltree_path_column => ltree_path
      end

      # Get self and siblings
      #
      # @return [ActiveRecord::Relation]
      def self_and_siblings
        ltree_scope.where(
          "SUBPATH(?, 0, NLEVEL(?) - 1) @> #{ltree_path_column} AND nlevel(#{ltree_path_column}) = NLEVEL(?)",
          ltree_path, ltree_path, ltree_path
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
        ltree_scope.where "? @> #{ltree_path_column} AND nlevel(#{ltree_path_column}) = NLEVEL(?) + 1",
          ltree_path, ltree_path
      end
    end
  end
end
