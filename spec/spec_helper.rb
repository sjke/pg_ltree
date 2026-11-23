require "bundler/setup"

require "logger"
require "active_record"
require "simplecov"
SimpleCov.start do
  add_filter "/spec/"
end

require "pg_ltree"

if ActiveRecord.respond_to?(:permanent_connection_checkout=)
  ActiveRecord.permanent_connection_checkout = :disallowed
end

if ActiveRecord.respond_to?(:deprecator)
  ActiveRecord.deprecator.disallowed_warnings = :all
end

require_relative "support/database"
require_relative "support/database_cleaner"
require_relative "support/shared_examples/querying_examples"

RSpec.configure do |config|
  config.order = :random
  config.disable_monkey_patching!
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
