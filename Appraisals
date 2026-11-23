def version_to_label(version)
  version.scan(/\d/).join
end

def add_appraise_for(activerecord_version:, pg_version:)
  appraise "activerecord_#{version_to_label(activerecord_version)}_pg_#{version_to_label(pg_version)}" do
    gem "activerecord", activerecord_version, require: "active_record"
    gem "pg", pg_version

    # The following used to be default gems and ceased to be in recent Ruby versions.
    # There is no harm in requiring them regardless of Ruby version.
    gem "base64"
    gem "benchmark"
    gem "bigdecimal"
    gem "logger"
    gem "mutex_m"
  end
end

ruby_version = Gem::Version.new(RUBY_VERSION)

supported_pg_versions = if ruby_version >= Gem::Version.new("3.2")
  ["~> 1.5", "~> 1.6", "~> 1.7"]
elsif ruby_version >= Gem::Version.new("3.1")
  ["~> 1.0", "~> 1.1", "~> 1.2", "~> 1.3", "~> 1.4", "~> 1.5", "~> 1.6", "~> 1.7"]
else
  ["~> 1.0", "~> 1.1", "~> 1.2", "~> 1.3", "~> 1.4", "~> 1.5", "~> 1.6"]
end

if ruby_version < Gem::Version.new("3.0")
  supported_pg_versions.each do |pg_version|
    add_appraise_for(activerecord_version: "~> 5.2", pg_version: pg_version)
  end
end

if ruby_version < Gem::Version.new("3.1")
  supported_pg_versions.each do |pg_version|
    add_appraise_for(activerecord_version: "~> 6.0", pg_version: pg_version)
  end
end

if ruby_version < Gem::Version.new("3.2")
  supported_pg_versions.each do |pg_version|
    add_appraise_for(activerecord_version: "~> 6.1", pg_version: pg_version)
  end
end

if ruby_version >= Gem::Version.new("2.7") && ruby_version < Gem::Version.new("3.4")
  supported_pg_versions.each do |pg_version|
    add_appraise_for(activerecord_version: "~> 7.0", pg_version: pg_version)
  end
end

if ruby_version >= Gem::Version.new("2.7") && ruby_version < Gem::Version.new("4.0")
  supported_pg_versions.each do |pg_version|
    add_appraise_for(activerecord_version: "~> 7.1", pg_version: pg_version)
  end
end

if ruby_version >= Gem::Version.new("3.1") && ruby_version < Gem::Version.new("4.0")
  supported_pg_versions.each do |pg_version|
    add_appraise_for(activerecord_version: "~> 7.2", pg_version: pg_version)
  end
end

if ruby_version >= Gem::Version.new("3.2")
  supported_pg_versions.each do |pg_version|
    add_appraise_for(activerecord_version: "~> 8.0", pg_version: pg_version)
    add_appraise_for(activerecord_version: "~> 8.1", pg_version: pg_version)
  end
end
