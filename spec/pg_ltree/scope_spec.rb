require "spec_helper"

RSpec.describe "ltree_scope" do
  let(:model) do
    Class.new(ActiveRecord::Base) do
      self.table_name = "nodes"
      ltree :path

      attr_accessor :user_id

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
    node1.user_id = 1
    expect(node1.children.count).to eq(1)
    expect(node1.children.first.user_id).to eq(1)

    node2 = model.where(user_id: 2, path: "Top").first
    node2.user_id = 2
    expect(node2.children.count).to eq(1)
    expect(node2.children.first.user_id).to eq(2)
  end
end
