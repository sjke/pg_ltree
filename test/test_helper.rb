require 'bundler'
begin
  Bundler.require(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts 'Run `bundle install` to install missing gems'
  exit e.status_code
end

require 'pg'
require 'pg_ltree'
require 'minitest/autorun'

class BaseTest < ActiveSupport::TestCase
  def setup
    prepare_db
  end

  def teardown
    drop_db
  end

  private

  def prepare_db
    begin
      db_connection = YAML.load_file(File.expand_path('../database.yml', __FILE__))
    rescue => e
      $stderr.puts e.message
      $stderr.puts 'Copy `database.yml.sample` to `database.yml` and configure connection to DB'
      exit 0
    end

    ActiveRecord::Base.establish_connection db_connection
    ActiveRecord::Schema.verbose = false

    ActiveRecord::Schema.define(version: 1) do
      enable_extension 'plpgsql'
      enable_extension 'ltree'

      create_table 'not_uniq_tree_nodes', force: :cascade do |t|
        t.string 'status'
        t.ltree  'new_path'
      end

      create_table 'tree_nodes', force: :cascade do |t|
        t.ltree 'path'
      end
    end
  end

  def drop_db
    tables = if ActiveRecord::VERSION::MAJOR < 5
               ActiveRecord::Base.connection.tables
             else
               ActiveRecord::Base.connection.data_sources
             end
    tables.each { |table| ActiveRecord::Base.connection.drop_table(table) }
  end
end

class NotUniqTreeNode < ActiveRecord::Base
  extend PgLtree::ScopedFor

  ltree :new_path
  ltree_scoped_for :status
end

class TreeNode < ActiveRecord::Base
  ltree
end
