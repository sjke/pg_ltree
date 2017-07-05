module PgLtree
  module Versions
    module Rails51
      def ltree(column = :path, options: { cascade: true })
        super

        before_destroy :delete_ltree_column_value if options[:cascade]
        include InstanceMethods
      end

      module InstanceMethods
        # Get lTree previous value
        #
        # Related changes in > Rails 5.1.0
        # https://github.com/rails/rails/pull/25337
        #
        # @return [String] ltree previous value
        def ltree_path_was
          public_send :"#{ltree_path_column}_before_last_save"
        end

        #
        # In order for for cascade_destroy to work with the current callbacks, let's first delete the column :/.
        # @author HoyaBoya [https://github.com/HoyaBoya]
        #
        def delete_ltree_column_value
          update!(ltree_path_column => nil)
        end
      end
    end
  end
end
