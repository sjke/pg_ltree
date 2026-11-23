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

    describe "when updating non-path attribute" do
      subject do
        Class.new(ActiveRecord::Base) do
          self.table_name = "nodes"
          ltree :path, cascade_update: true
        end
      end

      it "keeps child paths intact" do
        subject.create!([{path: "Top", user_id: 1}, {path: "Top.Science", user_id: 1}])
        subject.find_by(path: "Top").update!(user_id: 2)

        expect(subject.order(:id).pluck(:path)).to eq(["Top", "Top.Science"])
      end
    end

    describe "cascade when single table inheritance records" do
      let!(:base_class) do
        Class.new(ActiveRecord::Base) do
          self.table_name = "nodes"
          ltree :path, cascade_update: true
          def ltree_scope
            self.class.base_class
          end
        end
      end
      subject { Class.new(base_class) {} }

      before do
        subject.create!([{path: "Top"}, {path: "Top.Science"}])
        expect(subject.pluck(:path)).to include("Top", "Top.Science")
      end

      it "updates child record paths when parent path in changed" do
        subject.find_by(path: "Top").update path: "NewTop"

        expect(subject.pluck(:path)).to include("NewTop", "NewTop.Science")
      end
    end

    describe "when cascade is true (deprecated)" do
      it "emits a deprecation warning and enables cascade update and destroy" do
        expect(PgLtree.deprecator).to receive(:warn).with("'cascade' param is deprecated. Use 'cascade_update' and 'cascade_destroy' instead.")

        klass = Class.new(ActiveRecord::Base) do
          self.table_name = "nodes"
          ltree :path, cascade: true
        end

        klass.create!([{path: "Top"}, {path: "Top.Science"}])
        klass.find_by(path: "Top").update path: "NewTop"
        expect(klass.pluck(:path)).to include("NewTop", "NewTop.Science")

        klass.find_by(path: "NewTop").destroy
        expect(klass.count).to be_zero
      end
    end
  end

  context "destroy records" do
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
