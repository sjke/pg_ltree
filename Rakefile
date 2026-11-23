require "bundler/gem_tasks"
require "standard/rake"
require "rspec/core/rake_task"
require "appraisal"

desc "Run all tests"
RSpec::Core::RakeTask.new(:spec)

desc "Run linting"
task lint: :standard

desc "Run all tests across all appraisals"
task :test_all do
  sh "bundle exec appraisal rake spec"
end

task default: [:lint, :spec]
