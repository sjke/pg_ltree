RSpec.shared_examples "ltree querying" do
  let(:path_column) { subject.ltree_path_column }

  describe ".roots" do
    it "returns all root nodes" do
      expect(subject.roots.pluck(path_column)).to include("Top")
    end
  end

  describe ".at_depth" do
    it "returns nodes at a specific depth" do
      expect(subject.at_depth(2).pluck(path_column)).to include("Top.Science", "Top.Hobbies")
    end
  end

  describe ".leaves" do
    it "returns nodes with no descendants" do
      expect(subject.leaves.pluck(path_column)).to include("Top.Science.Astronomy.Astrophysics")
    end
  end
end
