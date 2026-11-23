require "spec_helper"

RSpec.describe "ltree_scope" do
  context "when overriding #ltree_scope" do
    let(:model) do
      Class.new(ActiveRecord::Base) do
        self.table_name = "nodes"
        ltree :path

        def ltree_scope
          self.class.where(user_id: user_id)
        end
      end
    end

    before do
      model.create!(path: "Top", user_id: 1)
      model.create!(path: "Top.Child", user_id: 1)
      model.create!(path: "Top", user_id: 2)
      model.create!(path: "Top.Child", user_id: 2)
    end

    it "scopes results to the current user_id" do
      node1 = model.where(user_id: 1, path: "Top").first
      expect(node1.children.count).to eq(1)
      expect(node1.children.first.user_id).to eq(1)

      node2 = model.where(user_id: 2, path: "Top").first
      expect(node2.children.count).to eq(1)
      expect(node2.children.first.user_id).to eq(2)
    end

    it "scopes cascade_update and cascade_destroy to the current user_id" do
      node1 = model.find_by!(user_id: 1, path: "Top")
      node1.update!(path: "NewTop")

      expect(model.where(user_id: 1).pluck(:path)).to contain_exactly("NewTop", "NewTop.Child")
      expect(model.where(user_id: 2).pluck(:path)).to contain_exactly("Top", "Top.Child")

      node1.destroy!
      expect(model.where(user_id: 1)).to be_empty
      expect(model.where(user_id: 2).pluck(:path)).to contain_exactly("Top", "Top.Child")
    end
  end

  context "with declarative scope: :user_id" do
    let(:scoped_model) do
      Class.new(ActiveRecord::Base) do
        self.table_name = "nodes"
        ltree :path, scope: :user_id
      end
    end

    it "scopes traversal and cascades by symbol attribute" do
      scoped_model.create!(path: "Top", user_id: 1)
      scoped_model.create!(path: "Top.Child", user_id: 1)
      scoped_model.create!(path: "Top", user_id: 2)
      scoped_model.create!(path: "Top.Child", user_id: 2)

      node1 = scoped_model.find_by!(user_id: 1, path: "Top")
      expect(node1.children.pluck(:user_id)).to eq([1])

      node1.update!(path: "Renamed")
      expect(scoped_model.where(user_id: 1).pluck(:path)).to contain_exactly("Renamed", "Renamed.Child")
      expect(scoped_model.where(user_id: 2).pluck(:path)).to contain_exactly("Top", "Top.Child")
    end
  end

  context "with declarative scope: [:user_id]" do
    let(:array_scoped_model) do
      Class.new(ActiveRecord::Base) do
        self.table_name = "nodes"
        ltree :path, scope: [:user_id]
      end
    end

    it "scopes traversal by array of attributes" do
      array_scoped_model.create!(path: "Top", user_id: 1)
      array_scoped_model.create!(path: "Top.Child", user_id: 1)
      array_scoped_model.create!(path: "Top.Child", user_id: 2)

      node1 = array_scoped_model.find_by!(user_id: 1, path: "Top")
      expect(node1.children.pluck(:user_id)).to eq([1])
    end
  end

  context "with declarative proc scope" do
    let(:proc_scoped_model) do
      Class.new(ActiveRecord::Base) do
        self.table_name = "nodes"
        ltree :path, scope: ->(record) { where(user_id: record.user_id) }
      end
    end

    let(:zero_arity_proc_model) do
      Class.new(ActiveRecord::Base) do
        self.table_name = "nodes"
        ltree :path, scope: -> { where(user_id: 1) }
      end
    end

    it "supports record-taking and zero-arity lambdas" do
      proc_scoped_model.create!(path: "Top", user_id: 1)
      proc_scoped_model.create!(path: "Top.Child", user_id: 1)
      proc_scoped_model.create!(path: "Top.Child", user_id: 2)

      node1 = proc_scoped_model.find_by!(user_id: 1, path: "Top")
      expect(node1.children.pluck(:user_id)).to eq([1])

      node2 = zero_arity_proc_model.create!(path: "Top", user_id: 2)
      expect(node2.children.pluck(:user_id)).to eq([1])
    end
  end
end
