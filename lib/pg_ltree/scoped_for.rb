module PgLtree
  module ScopedFor
    def ltree_scoped_for(columns = [])
      cattr_accessor :ltree_scoped_for

      self.ltree_scoped_for = Array.wrap(columns)

      include InstanceMethods
    end
    
    module InstanceMethods
      def scope
        self.class.where *(ltree_scoped_for.map { |column| { column => public_send(column) } })
      end
    end
  end
end
