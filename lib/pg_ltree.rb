require "active_support"
require "active_support/deprecation"

module PgLtree
  autoload :Base, "pg_ltree/base"
  autoload :Options, "pg_ltree/options"

  # @return [ActiveSupport::Deprecation]
  def self.deprecator
    @deprecator ||= ActiveSupport::Deprecation.new("2.0", "PgLtree")
  end
end

ActiveSupport.on_load(:active_record) do
  ActiveRecord::Base.include PgLtree::Base
end
