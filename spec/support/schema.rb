ActiveRecord::Schema.define do
  enable_extension "plpgsql"
  enable_extension "ltree"

  create_table "nodes", force: :cascade do |t|
    t.ltree "path"
    t.ltree "custom_path_column"
    t.integer "user_id"
  end
end
