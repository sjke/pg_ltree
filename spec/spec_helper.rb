require "bundler/setup"

require "logger"
require "active_record"
require "pg_ltree"

require_relative "support/database"
require_relative "support/database_cleaner"

RSpec.configure do |config|
  config.order = :random
  config.disable_monkey_patching!
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
