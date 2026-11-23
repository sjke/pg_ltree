module PgLtree
  module Model
    module PathInfo
      extend ActiveSupport::Concern

      included do
        # Get current scope for ltree queries
        #
        # @return [Class, ActiveRecord::Relation]
        def ltree_scope
          ltree_config ? ltree_config.resolve_scope(self) : self.class
        end

        # Get lTree column
        #
        # @return [Symbol, String] ltree column name
        delegate :ltree_path_column, to: :ltree_scope

        # Get lTree value
        #
        # @return [String, nil] ltree current value
        def ltree_path
          public_send ltree_path_column
        end

        # Get ltree original value before the save just occurred
        #
        # @return [String, nil] ltree previous value
        def ltree_path_before_last_save
          public_send :attribute_before_last_save, ltree_path_column
        end

        # Get lTree value in database
        #
        # @return [String, nil] ltree value in database
        def ltree_path_in_database
          public_send :attribute_in_database, ltree_path_column
        end

        # Get node height
        #
        # @return [Integer] height of the given node.
        def height
          return 0 if ltree_path.nil?

          max_level = self_and_descendants.maximum(Arel.sql("NLEVEL(#{ltree_qualified_column})"))
          return 0 if max_level.nil?

          max_level.to_i - depth
        end

        # Get node depth
        #
        # @return [Integer] node depth
        def depth
          path = ltree_path.to_s
          return 0 if path.empty?

          path.count(".") + 1
        end
      end
    end
  end
end
