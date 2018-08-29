module PgLtree
  module Versions
    module RailsOlderThan51
      def ltree(column = :path, options: { cascade: true })
        super
        include InstanceMethods
      end

      module InstanceMethods
        # Get lTree previous value
        #
        # Related changes in > Rails 5.1.0
        # https://github.com/rails/rails/pull/25337
        #
        # @return [String] Rails 5.1 replace attribute_was method with two methods, this is a wrapper for older rails
        def ltree_path_before_last_save
          public_send :attribute_was, ltree_path_column
        end

        #
        # @return [String] Rails 5.1 replace attribute_was method with two methods, this is a wrapper for older rails
        def ltree_path_in_database
          public_send :attribute_was, ltree_path_column
        end
      end
    end
  end
end
