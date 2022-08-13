require "yaml"

begin
  db_connection = YAML.load_file(File.expand_path("../database.yml", __dir__))
rescue => e
  warn e.message
  warn "Copy `test/database.yml.sample` to `test/database.yml` and configure connection to DB"
  exit 0
end

ActiveRecord::Base.establish_connection(db_connection)
ActiveRecord::Schema.verbose = false

require_relative "schema"
