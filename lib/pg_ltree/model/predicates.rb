module PgLtree
  module Model
    module Predicates
      extend ActiveSupport::Concern

      included do
        # Check what current node is root
        #
        # @return [Boolean] True - for root node, False - for childen node
        def root?
          depth == 1
        end

        # Check what current node have leaves
        #
        # @return [Boolean] True - if node have leaves, False - if node doesn't have leaves
        def leaf?
          leaves.count == 0
        end
      end
    end
  end
end
