module PgLtree
  module Configuration
    extend ActiveSupport::Concern

    class_methods do
      # Initialize ltree module for the model
      #
      # @param column [Symbol, String] lTree column name
      # @param cascade_update [Boolean] Update all child nodes when the self path is changed
      # @param cascade_destroy [Boolean] Destroy all child nodes on self-destroying
      # @param scope [Symbol, Array<Symbol>, Proc, nil] Optional scope attribute(s) or lambda
      def ltree(column = :path, cascade_update: true, cascade_destroy: true, cascade: nil, scope: nil)
        unless cascade.nil?
          PgLtree.deprecator.warn("'cascade' param is deprecated. Use 'cascade_update' and 'cascade_destroy' instead.")
        end

        @ltree_config = PgLtree::Options.new(
          column: column,
          cascade_update: cascade_update,
          cascade_destroy: cascade_destroy,
          cascade: cascade,
          scope: scope
        )

        include PgLtree::Model unless include?(PgLtree::Model)
        include PgLtree::Callbacks unless include?(PgLtree::Callbacks)
      end

      def ltree_config
        @ltree_config || (superclass.respond_to?(:ltree_config) ? superclass.ltree_config : nil)
      end

      def ltree_options
        ltree_config&.to_h
      end

      def ltree_option_for(key)
        ltree_config&.[](key)
      end
    end

    included do
      delegate :ltree_config, :ltree_option_for, to: :class
    end
  end
end
