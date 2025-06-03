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

SUPPORTED_PG_VERSIONS = ["~> 1.0", "~> 1.1", "~> 1.2", "~> 1.3", "~> 1.4", "~> 1.5"]

if Gem::Version.new(RUBY_VERSION) <= Gem::Version.new("3.0")
  SUPPORTED_PG_VERSIONS.map do |pg_version|
    add_appraise_for(activerecord_version: "~> 5.2", pg_version: pg_version)
  end
end

SUPPORTED_PG_VERSIONS.map do |pg_version|
  add_appraise_for(activerecord_version: "~> 6.0", pg_version: pg_version)
  add_appraise_for(activerecord_version: "~> 6.1", pg_version: pg_version)
end

if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("2.7")
  SUPPORTED_PG_VERSIONS.map do |pg_version|
    add_appraise_for(activerecord_version: "~> 7.0", pg_version: pg_version)
    add_appraise_for(activerecord_version: "~> 7.1", pg_version: pg_version)
  end
end

if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.1")
  SUPPORTED_PG_VERSIONS.map do |pg_version|
    add_appraise_for(activerecord_version: "~> 7.2", pg_version: pg_version)
  end
end

if Gem::Version.new(RUBY_VERSION) >= Gem::Version.new("3.2")
  SUPPORTED_PG_VERSIONS.map do |pg_version|
    add_appraise_for(activerecord_version: "~> 8.0", pg_version: pg_version)
  end
end
