require 'test_helper'

class PgLtree::LtreeTest < ActiveSupport::TestCase

  def setup
    %w(
      Top
      Top.Science
      Top.Science.Astronomy
      Top.Science.Astronomy.Astrophysics
      Top.Science.Astronomy.Cosmology
      Top.Hobbies
      Top.Hobbies.Amateurs_Astronomy
      Top.Collections
      Top.Collections.Pictures
      Top.Collections.Pictures.Astronomy
      Top.Collections.Pictures.Astronomy.Stars
      Top.Collections.Pictures.Astronomy.Galaxies
      Top.Collections.Pictures.Astronomy.Astronauts
    ).each do |path|
      TreeNode.create! path: path
    end
  end

  def teardown
    TreeNode.delete_all
  end

  test "Default configuration" do
    assert_equal TreeNode.ltree_path_column, :path
  end

  test "Custom configuration" do
    assert_equal NotUniqTreeNode.ltree_path_column, :new_path
  end

  test '#roots' do
    assert_equal TreeNode.roots.pluck(:path), ['Top']
  end

  test '#at_depth' do
    assert_equal TreeNode.at_depth(5).pluck(:path), %w(
      Top.Collections.Pictures.Astronomy.Stars
      Top.Collections.Pictures.Astronomy.Galaxies
      Top.Collections.Pictures.Astronomy.Astronauts
    )
  end

  test '#leaves' do
    assert_equal TreeNode.leaves.pluck(:path), %w(
      Top.Science.Astronomy.Astrophysics
      Top.Science.Astronomy.Cosmology
      Top.Hobbies.Amateurs_Astronomy
      Top.Collections.Pictures.Astronomy.Stars
      Top.Collections.Pictures.Astronomy.Galaxies
      Top.Collections.Pictures.Astronomy.Astronauts
    )
  end

  test '#where_path_liked' do
    assert_equal TreeNode.where_path_liked('*{2}.Astronomy|Pictures').pluck(:path), %w(
      Top.Science.Astronomy
      Top.Collections.Pictures
    )
  end

  test '.root?' do
    assert TreeNode.find_by(path: 'Top').root?
    assert_not TreeNode.find_by(path: 'Top.Science').root?
  end

  test '.depth' do
    assert_equal TreeNode.find_by(path: 'Top.Hobbies.Amateurs_Astronomy').depth, 3
  end

  test '.root' do
    assert_equal TreeNode.find_by(path: 'Top.Hobbies.Amateurs_Astronomy').root.path, 'Top'
  end

  test '.parent' do
    assert_equal TreeNode.find_by(path: 'Top.Collections.Pictures.Astronomy.Astronauts').parent.path,
      'Top.Collections.Pictures.Astronomy'
  end

  test '.leaves' do
    assert_equal TreeNode.find_by(path: 'Top.Science').leaves.pluck(:path), %w(
      Top.Science.Astronomy.Astrophysics
      Top.Science.Astronomy.Cosmology
    )
  end

  test '.leaf?' do
    assert_not TreeNode.find_by(path: 'Top').leaf?
    assert TreeNode.find_by(path: 'Top.Collections.Pictures.Astronomy.Astronauts').leaf?
  end

  test '.self_and_ancestors' do
    assert_equal TreeNode.find_by(path: 'Top.Collections.Pictures.Astronomy.Astronauts').self_and_ancestors.pluck(:path), %w(
      Top
      Top.Collections
      Top.Collections.Pictures
      Top.Collections.Pictures.Astronomy
      Top.Collections.Pictures.Astronomy.Astronauts
    )
  end

  test '.ancestors' do
    assert_equal TreeNode.find_by(path: 'Top.Collections.Pictures.Astronomy.Astronauts').ancestors.pluck(:path), %w(
      Top
      Top.Collections
      Top.Collections.Pictures
      Top.Collections.Pictures.Astronomy
    )
  end

  test '.self_and_descendents' do
    assert_equal TreeNode.find_by(path: 'Top.Science').self_and_descendents.pluck(:path), %w(
      Top.Science
      Top.Science.Astronomy
      Top.Science.Astronomy.Astrophysics
      Top.Science.Astronomy.Cosmology
    )
  end

  test '.descendents' do
    assert_equal TreeNode.find_by(path: 'Top.Science').descendents.pluck(:path), %w(
      Top.Science.Astronomy
      Top.Science.Astronomy.Astrophysics
      Top.Science.Astronomy.Cosmology
    )
  end

  test '.self_and_siblings' do
    assert_equal TreeNode.find_by(path: 'Top.Collections.Pictures.Astronomy.Stars').self_and_siblings.pluck(:path), %w(
      Top.Collections.Pictures.Astronomy.Stars
      Top.Collections.Pictures.Astronomy.Galaxies
      Top.Collections.Pictures.Astronomy.Astronauts
    )
  end


  test '.siblings' do
    assert_equal TreeNode.find_by(path: 'Top.Collections.Pictures.Astronomy.Stars').siblings.pluck(:path), %w(
      Top.Collections.Pictures.Astronomy.Galaxies
      Top.Collections.Pictures.Astronomy.Astronauts
    )
  end

  test '.children' do
    assert_equal TreeNode.find_by(path: 'Top.Hobbies').children.pluck(:path), %w(
      Top.Hobbies.Amateurs_Astronomy
    )
  end
end
