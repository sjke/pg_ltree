def version_to_label(version)
  version.scan(/\d/).join
end

def add_appraise_for(activerecord_version:, pg_version:)
  appraise "activerecord_#{version_to_label(activerecord_version)}_pg_#{version_to_label(pg_version)}" do
    gem "activerecord", activerecord_version, require: "active_record"
    gem "pg", pg_version
  end
end

SUPPORTED_PG_VERSIONS = ["~> 1.0", "~> 1.1", "~> 1.2", "~> 1.3", "~> 1.4"]

if RUBY_VERSION <= "3.0"
  SUPPORTED_PG_VERSIONS.map do |pg_version|
    add_appraise_for(activerecord_version: "~> 5.2", pg_version: pg_version)
  end
end

SUPPORTED_PG_VERSIONS.map do |pg_version|
  add_appraise_for(activerecord_version: "~> 6.0", pg_version: pg_version)
  add_appraise_for(activerecord_version: "~> 6.1", pg_version: pg_version)
end

if RUBY_VERSION >= "2.7"
  SUPPORTED_PG_VERSIONS.map do |pg_version|
    add_appraise_for(activerecord_version: "~> 7.0", pg_version: pg_version)
  end
end
