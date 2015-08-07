$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "pg_ltree/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "pg_ltree"
  s.version     = PgLtree::VERSION
  s.authors     = ["Andrei Panamarenka"]
  s.email       = ["andrei.panamarenka@gmail.com"]
  s.homepage    = "https://github.com/sjke/pg_lree"
  s.summary     = "Organise ActiveRecord model into a tree structure with PostgreSQL LTree"
  s.description = "Organise ActiveRecord model into a tree structure with PostgreSQL LTree (Use clean ltree without additional fields)"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", ">= 4.0.0"

  s.add_development_dependency "sqlite3"
end
