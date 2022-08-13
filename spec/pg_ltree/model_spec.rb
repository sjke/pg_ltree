require "spec_helper"

RSpec.describe PgLtree::Model do
  subject do
    Class.new(ActiveRecord::Base) do
      self.table_name = "nodes"
      ltree :path
    end
  end

  before do
    subject.create!([
      {path: "Top"},
      {path: "Top.Science"},
      {path: "Top.Science.Astronomy"},
      {path: "Top.Science.Astronomy.Astrophysics"},
      {path: "Top.Science.Astronomy.Cosmology"},
      {path: "Top.Hobbies"},
      {path: "Top.Hobbies.Amateurs_Astronomy"},
      {path: "Top.Collections"},
      {path: "Top.Collections.Pictures"},
      {path: "Top.Collections.Pictures.Astronomy"},
      {path: "Top.Collections.Pictures.Astronomy.Stars"},
      {path: "Top.Collections.Pictures.Astronomy.Galaxies"},
      {path: "Top.Collections.Pictures.Astronomy.Astronauts"},
      {path: "Top.Collections.Videos"},
      {path: "Top.Collections.Videos.Vacation"},
      {path: "Top.Collections.Videos.NewYear"}
    ])
  end

  describe "#roots" do
    it "returns all root paths" do
      expect(subject.roots.pluck(:path)).to include("Top")
    end
  end

  describe "#at_depth" do
    it "returns empty array with when depth is zero" do
      expect(subject.at_depth(0).pluck(:path)).to eq([])
    end

    it "returns nodes on requested level" do
      expect(subject.at_depth(5).pluck(:path)).to include(*%w[
        Top.Collections.Pictures.Astronomy.Stars
        Top.Collections.Pictures.Astronomy.Galaxies
        Top.Collections.Pictures.Astronomy.Astronauts
      ])
    end

    it "returns empty array when depth is outside available range" do
      expect(subject.at_depth(100_000).pluck(:path)).to eq([])
    end
  end

  describe "#leaves" do
    it "returns all paths which are leaves" do
      expect(subject.leaves.pluck(:path)).to include(*%w[
        Top.Science.Astronomy.Astrophysics
        Top.Science.Astronomy.Cosmology
        Top.Hobbies.Amateurs_Astronomy
        Top.Collections.Pictures.Astronomy.Stars
        Top.Collections.Pictures.Astronomy.Galaxies
        Top.Collections.Pictures.Astronomy.Astronauts
        Top.Collections.Videos.Vacation
        Top.Collections.Videos.NewYear
      ])
    end

    it "returns paths which are leaves except ignored one" do
      expect(subject.where("path <> 'Top.Collections.Pictures.Astronomy.Stars'").leaves.pluck(:path)).to include(*%w[
        Top.Science.Astronomy.Astrophysics
        Top.Science.Astronomy.Cosmology
        Top.Hobbies.Amateurs_Astronomy
        Top.Collections.Pictures.Astronomy.Galaxies
        Top.Collections.Pictures.Astronomy.Astronauts
        Top.Collections.Videos.Vacation
        Top.Collections.Videos.NewYear
      ])
    end
  end

  describe "#where_path_liked" do
    it "returns array of paths which liked to query" do
      expect(subject.where_path_liked("*{2}.Astronomy|Pictures").pluck(:path)).to include(*%w[
        Top.Science.Astronomy
        Top.Collections.Pictures
      ])
    end
  end

  describe "#where_path_matches_ltxtquery" do
    it "returns array of path which matched to query" do
      expect(subject.where_path_matches_ltxtquery("Astro*% & !pictures@").pluck(:path)).to include(*%w[
        Top.Science.Astronomy
        Top.Science.Astronomy.Astrophysics
        Top.Science.Astronomy.Cosmology
        Top.Hobbies.Amateurs_Astronomy
      ])
    end
  end

  describe ".height" do
    it "returns height for root path" do
      expect(subject.find_by(path: "Top").height).to eq(4)
    end

    it "returns height for leave path" do
      expect(subject.find_by(path: "Top.Science.Astronomy.Astrophysics").height).to be_zero
    end
  end

  describe ".depth" do
    it "returns depth for selected record from db" do
      expect(subject.find_by(path: "Top.Hobbies.Amateurs_Astronomy").depth).to eq(3)
    end

    it "returns depth for new record" do
      expect(subject.new(path: "Group.Nested.Depth.Value").depth).to eq(4)
    end
  end

  describe ".root" do
    it "returns root paths for selected record" do
      expect(subject.find_by(path: "Top.Hobbies.Amateurs_Astronomy").root.path).to eq("Top")
    end
  end

  describe ".root?" do
    it "returns true when selected record is root" do
      expect(subject.find_by(path: "Top").root?).to be_truthy
    end

    it "returns false when selected record is not root" do
      expect(subject.find_by(path: "Top.Science").root?).to be_falsey
    end
  end

  describe ".parent" do
    it "returns parenth path for selected record" do
      expect(subject.find_by(path: "Top.Collections.Pictures.Astronomy.Astronauts").parent.path).to eq("Top.Collections.Pictures.Astronomy")
    end
  end

  describe ".children" do
    it "returns children paths for selected record" do
      expect(subject.find_by(path: "Top.Hobbies").children.pluck(:path)).to include(*%w[Top.Hobbies.Amateurs_Astronomy])
    end
  end

  describe ".leaves" do
    it "returns leave paths for selected record" do
      expect(subject.find_by(path: "Top.Science").leaves.pluck(:path)).to include(*%w[
        Top.Science.Astronomy.Astrophysics
        Top.Science.Astronomy.Cosmology
      ])
    end
  end

  describe ".leaf?" do
    it "returns false when selected record is leaf" do
      expect(subject.find_by(path: "Top").leaf?).to be_falsey
    end

    it "returns true when selected record is not leaf" do
      expect(subject.find_by(path: "Top.Collections.Pictures.Astronomy.Astronauts").leaf?).to be_truthy
    end
  end

  describe ".self_and_ancestors" do
    it "returns self and ancestor paths for selected record" do
      expect(subject.find_by(path: "Top.Collections.Pictures.Astronomy.Astronauts").self_and_ancestors.pluck(:path)).to include(*%w[
        Top
        Top.Collections
        Top.Collections.Pictures
        Top.Collections.Pictures.Astronomy
        Top.Collections.Pictures.Astronomy.Astronauts
      ])
    end
  end

  describe ".ancestors" do
    it "returns ancestor paths for selected record" do
      expect(subject.find_by(path: "Top.Collections.Pictures.Astronomy.Astronauts").ancestors.pluck(:path)).to include(*%w[
        Top
        Top.Collections
        Top.Collections.Pictures
        Top.Collections.Pictures.Astronomy
      ])
    end
  end

  describe ".self_and_descendants" do
    it "returns self and descendant paths for selected record" do
      expect(subject.find_by(path: "Top.Science").self_and_descendants.pluck(:path)).to include(*%w[
        Top.Science
        Top.Science.Astronomy
        Top.Science.Astronomy.Astrophysics
        Top.Science.Astronomy.Cosmology
      ])
    end
  end

  describe ".descendants" do
    it "returns descendant paths for selected record" do
      expect(subject.find_by(path: "Top.Science").descendants.pluck(:path)).to include(*%w[
        Top.Science.Astronomy
        Top.Science.Astronomy.Astrophysics
        Top.Science.Astronomy.Cosmology
      ])
    end
  end

  describe ".self_and_siblings" do
    it "returns self and sibling paths for selected record" do
      expect(subject.find_by(path: "Top.Collections.Pictures.Astronomy.Stars").self_and_siblings.pluck(:path)).to include(*%w[
        Top.Collections.Pictures.Astronomy.Stars
        Top.Collections.Pictures.Astronomy.Galaxies
        Top.Collections.Pictures.Astronomy.Astronauts
      ])
    end
  end

  describe ".siblings" do
    it "returns sibling paths for selected record" do
      expect(subject.find_by(path: "Top.Collections.Pictures.Astronomy.Stars").siblings.pluck(:path)).to include(*%w[
        Top.Collections.Pictures.Astronomy.Galaxies
        Top.Collections.Pictures.Astronomy.Astronauts
      ])
    end
  end
end
