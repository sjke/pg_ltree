require_relative "model"
require_relative "callbacks"

module PgLtree
  module Base
    extend ActiveSupport::Concern

    class_methods do
      attr_reader :ltree_options

      # Initialize ltree module for the model
      #
      # @param column [String] lTree column name
      # @param cascade_update [Boolean] Update all child nodes when the self path is changed
      # @param cascade_destroy [Boolean] Destroy all child nodes on self-destroying
      def ltree(column = :path, cascade_update: true, cascade_destroy: true, cascade: nil)
        if cascade
          ActiveSupport::Deprecation.warn("'cascade' param is deprecated. Use 'cascade_update' and 'cascade_destroy' instead.")
        end

        @ltree_options = {
          column: column,
          cascade_update: cascade.nil? ? cascade_update : cascade,
          cascade_destroy: cascade.nil? ? cascade_destroy : cascade
        }

        send(:include, PgLtree::Model)
        send(:include, PgLtree::Callbacks)
      end

      def ltree_option_for(key)
        ltree_options[key]
      end
    end

    included do
      delegate :ltree_option_for, to: :class
    end
  end
end
