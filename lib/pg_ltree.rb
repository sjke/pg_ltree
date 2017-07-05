require 'pg_ltree/ltree'
require 'pg_ltree/scoped_for'
require 'pg_ltree/version'

Dir[File.expand_path('../pg_ltree/versions/**/*.rb', __FILE__)].each { |file| require file }

if defined?(ActiveRecord)
  ActiveRecord::Base.extend(PgLtree::Ltree)

  # The behavior of _was changes in Rails 5.1
  # http://blog.toshima.ru/2017/04/06/saved-change-to-attribute.html
  if ActiveRecord::VERSION::MAJOR > 5 || (ActiveRecord::VERSION::MAJOR == 5 && ActiveRecord::VERSION::MINOR >= 1)
    ActiveRecord::Base.extend(PgLtree::Versions::Rails51)
  end
end
