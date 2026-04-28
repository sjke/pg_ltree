require_relative "model/querying"
require_relative "model/traversal"
require_relative "model/predicates"
require_relative "model/path_info"
require_relative "model/cascade"

module PgLtree
  module Model
    extend ActiveSupport::Concern

    included do
      include PathInfo
      include Querying
      include Traversal
      include Predicates
      include Cascade
    end
  end
end
