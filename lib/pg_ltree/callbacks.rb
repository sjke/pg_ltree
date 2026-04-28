module PgLtree
  module Callbacks
    extend ActiveSupport::Concern

    included do
      after_commit :cascade_update, on: :update, if: -> { ltree_option_for :cascade_update }
      after_commit :cascade_destroy, on: :destroy, if: -> { ltree_option_for :cascade_destroy }
    end
  end
end
