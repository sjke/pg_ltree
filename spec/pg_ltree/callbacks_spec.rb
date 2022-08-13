require "spec_helper"

RSpec.describe PgLtree::Callbacks do
  context "update records" do
    describe "when cascade_update is true" do
      subject do
        Class.new(ActiveRecord::Base) do
          self.table_name = "nodes"
          ltree :path, cascade_update: true
        end
      end

      before do
        subject.create!([{path: "Top"}, {path: "Top.Science"}])
        expect(subject.pluck(:path)).to include("Top", "Top.Science")
      end

      it "updates child record paths when parent path in changed" do
        subject.find_by(path: "Top").update path: "NewTop"

        expect(subject.pluck(:path)).to include("NewTop", "NewTop.Science")
      end
    end

    describe "when cascade_update is false" do
      subject do
        Class.new(ActiveRecord::Base) do
          self.table_name = "nodes"
          ltree :path, cascade_update: false
        end
      end

      before do
        subject.create!([{path: "Top"}, {path: "Top.Science"}])
        expect(subject.pluck(:path)).to include("Top", "Top.Science")
      end

      it "not updates child record paths when parent path in changed" do
        subject.find_by(path: "Top").update path: "NewTop"

        expect(subject.pluck(:path)).to include("NewTop", "Top.Science")
      end
    end
  end

  context "desctroy records" do
    describe "when cascade_destroy is true" do
      subject do
        Class.new(ActiveRecord::Base) do
          self.table_name = "nodes"
          ltree :path, cascade_destroy: true
        end
      end

      before do
        subject.create!([{path: "Top"}, {path: "Top.Science"}])
        expect(subject.pluck(:path)).to include("Top", "Top.Science")
      end

      it "deletes child records when parent is destroyed" do
        subject.find_by(path: "Top").destroy

        expect(subject.pluck(:path)).to eq([])
      end
    end

    describe "when cascade_destroy is false" do
      subject do
        Class.new(ActiveRecord::Base) do
          self.table_name = "nodes"
          ltree :path, cascade_destroy: false
        end
      end

      before do
        subject.create!([{path: "Top"}, {path: "Top.Science"}])
        expect(subject.pluck(:path)).to include("Top", "Top.Science")
      end

      it "not deletes child records when parent is destroy" do
        subject.find_by(path: "Top").destroy

        expect(subject.pluck(:path)).to include("Top.Science")
      end
    end
  end
end
