require 'bundler/gem_tasks'

require 'rake/testtask'
require 'rdoc/task'

gemspec = eval(File.read(Dir['*.gemspec'].first))

RDoc::Task.new(:rdoc) do |rdoc|
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title    = 'PgLtree'
  rdoc.options << '--line-numbers'
  rdoc.rdoc_files.include('README.rdoc')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

Rake::TestTask.new(:test) do |t|
  t.libs << 'lib'
  t.libs << 'test'
  t.pattern = 'test/**/*_test.rb'
  t.verbose = false
end

desc 'Default: run unit tests.'
task default: 'test:all'

namespace :test do
  AVAILABLE_CASES = %w(
    activerecord_40_pg_017 activerecord_40_pg_018
    activerecord_41_pg_017 activerecord_41_pg_018
    activerecord_42_pg_017 activerecord_42_pg_018
    activerecord_50_pg_018
  ).freeze

  AVAILABLE_CASES.each do |version|
    desc "Test pg_ltree against #{version}"
    task version do
      sh "BUNDLE_GEMFILE='gemfiles/#{version}.gemfile' bundle install --quiet"
      sh "BUNDLE_GEMFILE='gemfiles/#{version}.gemfile' bundle exec rake -t test"
    end
  end

  desc 'Run all tests for pg_ltree'
  task :all do
    AVAILABLE_CASES.each do |version|
      sh "BUNDLE_GEMFILE='gemfiles/#{version}.gemfile' bundle install --quiet"
      sh "BUNDLE_GEMFILE='gemfiles/#{version}.gemfile' bundle exec rake -t test"
    end
  end
end
