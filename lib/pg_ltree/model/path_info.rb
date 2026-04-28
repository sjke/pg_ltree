module PgLtree
  module Model
    module PathInfo
      extend ActiveSupport::Concern

      included do
        # Get current class as scope
        #
        # @return current class
        def ltree_scope
          self.class
        end

        # Get lTree column
        #
        # @return [String] ltree column name
        delegate :ltree_path_column, to: :ltree_scope

        # Get lTree value
        #
        # @return [String] ltree current value
        def ltree_path
          public_send ltree_path_column
        end

        # Get ltree original value before the save just occurred
        #
        # @return [String] ltree previous value
        def ltree_path_before_last_save
          public_send :attribute_before_last_save, ltree_path_column
        end

        # Get lTree value in database
        #
        # @return [String] ltree value in database
        def ltree_path_in_database
          public_send :attribute_in_database, ltree_path_column
        end

        # Get node height
        #
        # @return [Number] height of the given node.
        def height
          self_and_descendants.maximum("NLEVEL(#{ltree_path_column})") - depth.to_i
        end

        # Get node depth
        #
        # @return [Integer] node depth
        def depth
          ActiveRecord::Base.connection.select_all("SELECT NLEVEL('#{ltree_path}')").rows.flatten.first.to_i
        end
      end
    end
  end
end
