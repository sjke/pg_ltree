unless RUBY_VERSION =~ /^3/
  # Rails 5.2
  appraise "activerecord_52_pg_10" do
    gem 'activerecord', '~> 5.2', require: 'active_record'
    gem 'pg', '~> 1.0'
  end
  appraise "activerecord_52_pg_11" do
    gem 'activerecord', '~> 5.2', require: 'active_record'
    gem 'pg', '~> 1.1'
  end
  appraise "activerecord_52_pg_12" do
    gem 'activerecord', '~> 5.2', require: 'active_record'
    gem 'pg', '~> 1.2'
  end
end

# Rails 6.0
appraise "activerecord_60_pg_10" do
  gem 'activerecord', '~> 6.0', require: 'active_record'
  gem 'pg', '~> 1.0'
end
appraise "activerecord_60_pg_11" do
  gem 'activerecord', '~> 6.0', require: 'active_record'
  gem 'pg', '~> 1.1'
end
appraise "activerecord_60_pg_12" do
  gem 'activerecord', '~> 6.0', require: 'active_record'
  gem 'pg', '~> 1.2'
end

# Rails 6.1
appraise "activerecord_61_pg_10" do
  gem 'activerecord', '~> 6.1', require: 'active_record'
  gem 'pg', '~> 1.0'
end
appraise "activerecord_61_pg_11" do
  gem 'activerecord', '~> 6.1', require: 'active_record'
  gem 'pg', '~> 1.1'
end
appraise "activerecord_61_pg_12" do
  gem 'activerecord', '~> 6.1', require: 'active_record'
  gem 'pg', '~> 1.2'
end

if RUBY_VERSION >= '2.7'
  # Rails 7
  appraise "activerecord_70_pg_10" do
    gem 'activerecord', '~> 7.0', require: 'active_record'
    gem 'pg', '~> 1.0'
  end
  appraise "activerecord_70_pg_11" do
    gem 'activerecord', '~> 7.0', require: 'active_record'
    gem 'pg', '~> 1.1'
  end
  appraise "activerecord_70_pg_12" do
    gem 'activerecord', '~> 7.0', require: 'active_record'
    gem 'pg', '~> 1.2'
  end
end