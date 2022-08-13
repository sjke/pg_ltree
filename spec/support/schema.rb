ActiveRecord::Schema.define do
  enable_extension "plpgsql"
  enable_extension "ltree"

  create_table "nodes", force: :cascade do |t|
    t.ltree "path"
  end
end
