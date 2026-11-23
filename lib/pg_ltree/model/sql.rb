module PgLtree
  module Model
    module Sql
      extend ActiveSupport::Concern

      class_methods do
        # Quoted ltree column name for the current model's connection adapter
        #
        # @return [String]
        def ltree_quoted_column
          connection_pool.with_connection do |connection|
            connection.quote_column_name(ltree_path_column)
          end
        end

        # Table-qualified, quoted ltree column expression
        #
        # @return [String]
        def ltree_qualified_column
          "#{quoted_table_name}.#{ltree_quoted_column}"
        end
      end

      included do
        delegate :ltree_quoted_column, :ltree_qualified_column, to: :class
      end
    end
  end
end
