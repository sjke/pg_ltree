$LOAD_PATH.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "pg_ltree/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name = "pg_ltree"
  s.version = PgLtree::VERSION
  s.authors = ["Andrei Panamarenka"]
  s.email = ["andrei.panamarenka@gmail.com"]
  s.homepage = "https://github.com/sjke/pg_ltree"
  s.summary = "Organize ActiveRecord model into a tree structure using PostgreSQL LTree"
  s.description = "Organize ActiveRecord model into a tree structure using PostgreSQL LTree"
  s.license = "MIT"
  s.required_ruby_version = ">= 2.7.0"

  s.files = Dir["{lib}/**/*", "MIT-LICENSE", "Rakefile", "README.rdoc"]

  s.add_dependency "activerecord", ">= 5.2", "< 9.0"
  s.add_dependency "pg", ">= 0.19", "< 2"

  s.add_development_dependency "bundler"
  s.add_development_dependency "rake"
  s.add_development_dependency "pry"
  s.add_development_dependency "standard"
  s.add_development_dependency "yard", "~> 0.9"
  s.add_development_dependency "appraisal", "~> 2.5"
  s.add_development_dependency "rspec", "~> 3.13"
  s.add_development_dependency "database_cleaner", "~> 2.1"
  s.add_development_dependency "simplecov", "~> 0.22"
end