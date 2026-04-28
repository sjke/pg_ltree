require_relative "model"
require_relative "callbacks"
require_relative "configuration"

module PgLtree
  module Base
    extend ActiveSupport::Concern
    include Configuration
  end
end
