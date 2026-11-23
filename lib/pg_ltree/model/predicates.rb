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

        # Check what current node is a leaf
        #
        # @return [Boolean] True - if node has no descendants, False - if node has descendants
        def leaf?
          !descendants.exists?
        end
      end
    end
  end
end
