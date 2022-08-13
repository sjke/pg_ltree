require "bundler/gem_tasks"
require "standard/rake"
require "rspec/core/rake_task"
require "rdoc/task"
require "appraisal"

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = "rdoc"
  rdoc.title = "PgLtree"
  rdoc.options << "--line-numbers"
  rdoc.rdoc_files.include("README.rdoc")
  rdoc.rdoc_files.include("lib/**/*.rb")
end

RSpec::Core::RakeTask.new(:spec)

task default: :spec
