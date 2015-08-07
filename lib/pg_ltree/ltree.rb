module PgLtree
  module Ltree
    def ltree(column = :path)
      cattr_accessor :ltree_path_column

      self.ltree_path_column = column

      include InstanceMethods
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
      where "NLEVEL(#{ltree_path_column}) = ?", depth
    end

    # Get all leaves
    #
    # @return [ActiveRecord::Relation] relations of node's leaves
    def leaves
      subquery = select("count(DISTINCT subquery.#{ltree_path_column}) = 1").to_sql
      subquery << "AS subquery WHERE subquery.#{ltree_path_column} <@ #{table_name}.#{ltree_path_column}"
      where subquery
    end
  
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
        nlevel == 1
      end

      # Get node depth
      #
      # @return [Integer] node depth
      def depth
        ltree_scope.distinct.pluck("NLEVEL('#{ltree_path}')").first || nil
      end
      
      # Check what current node have leaves
      #
      # @return [Boolean] True - if node have leaves, False - if node doesn't have leaves
      def leaf?
        ltree_scope.where("#{ltree_path_column} <@ ?", ltree_path).count != 1
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
        ltree_scope.leaves.where "path <@ ?", ltree_path
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

      # Get self and children
      #
      # @return [Array]
      def self_and_children
        [self + children]
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