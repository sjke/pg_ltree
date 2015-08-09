module PgLtree
  # Narrowing the Scope for ActiveRecord Model
  # @note When model have composite uniq key (for example: state + path), you should use this module for narrowing the scope
  #
  # @author a.ponomarenko
  module ScopedFor

    # Define base instance scope for model by columns
    #
    # @param columns [Array] List of scoped fields
    def ltree_scoped_for(columns = [])
      cattr_accessor :ltree_scoped_for

      self.ltree_scoped_for = Array.wrap(columns)

      extend ClassMethods
      include InstanceMethods
    end

    # Define class methods
    module ClassMethods
      # Get all leaves
      #
      # @return [ActiveRecord::Relation] relations of node's leaves
      def leaves
        subquery =
          select("COUNT(subquery.#{ltree_path_column}) = (SELECT COUNT(DISTINCT #{ltree_scoped_for.first}) FROM #{table_name})")
          .from("#{table_name} AS subquery")
          .where("subquery.#{ltree_path_column} <@ #{table_name}.#{ltree_path_column}").to_sql
        where subquery
      end
    end

    # Define instance methods
    module InstanceMethods

      # Get default scope of ltree
      #
      # @return current class
      def ltree_scope
        self.class.where *(ltree_scoped_for.map { |column| { column => public_send(column) } })
      end
    end
  end
end
