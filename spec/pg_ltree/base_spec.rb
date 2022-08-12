require "spec_helper"

RSpec.describe PgLtree::Base do
  subject { model_class }

  let!(:model_class) do
    Class.new(ActiveRecord::Base) do
      self.table_name = "nodes"
      ltree :path
    end
  end

  describe "inject PgLtree modules" do
    describe "when call #ltree" do
      subject { model_class.included_modules }

      it "includes PgLtree::Model" do
        expect(subject).to include(PgLtree::Model)
      end

      it "includes PgLtree::Model" do
        expect(subject).to include(PgLtree::Callbacks)
      end
    end

    describe "when not call #ltree" do
      subject { Class.new(ActiveRecord::Base).included_modules }

      it "not includes PgLtree::Model" do
        expect(subject).not_to include(PgLtree::Model)
      end

      it "not includes PgLtree::Model" do
        expect(subject).not_to include(PgLtree::Callbacks)
      end
    end
  end

  describe "configuration" do
    it "defines ltree options" do
      expect(subject.ltree_options).to eq(cascade_destroy: true, cascade_update: true, column: :path)
    end

    {
      column: :path,
      cascade_destroy: true,
      cascade_update: true,
      unknown_key: nil
    }.map do |key, value|
      it "returns ltree option '#{key}' with '#{value}' as value" do
        expect(subject.ltree_option_for(key)).to eq(value)
      end
    end
  end
end
