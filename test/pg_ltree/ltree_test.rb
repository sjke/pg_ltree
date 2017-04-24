require 'test_helper'

class PgLtree::LtreeTest < BaseTest
  def setup
    super
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

  test 'Default configuration' do
    assert_equal TreeNode.ltree_path_column, :path
  end

  test 'Custom configuration' do
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

  test '#where_path_matches_ltxtquery' do
    assert_equal TreeNode.where_path_matches_ltxtquery('Astro*% & !pictures@').pluck(:path), %w(
      Top.Science.Astronomy
      Top.Science.Astronomy.Astrophysics
      Top.Science.Astronomy.Cosmology
      Top.Hobbies.Amateurs_Astronomy
    )
  end

  test '.root?' do
    assert TreeNode.find_by(path: 'Top').root?
    assert_not TreeNode.find_by(path: 'Top.Science').root?
  end

  test '.height' do
    assert_equal 4, TreeNode.find_by(path: 'Top').height
    assert_equal 0, TreeNode.find_by(path: 'Top.Science.Astronomy.Astrophysics').height
  end

  test '.depth' do
    assert_equal TreeNode.find_by(path: 'Top.Hobbies.Amateurs_Astronomy').depth, 3
  end

  test '.depth on new record' do
    assert_equal TreeNode.new(path: 'Top.Hobbies.Amateurs_Astronomy').depth, 3
  end

  test '.depth on new record when database is empty' do
    TreeNode.delete_all
    assert_equal TreeNode.new(path: 'Top.Hobbies.Amateurs_Astronomy').depth, 3
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

  test '.self_and_descendants' do
    assert_equal TreeNode.find_by(path: 'Top.Science').self_and_descendants.pluck(:path), %w(
      Top.Science
      Top.Science.Astronomy
      Top.Science.Astronomy.Astrophysics
      Top.Science.Astronomy.Cosmology
    )
  end

  test '.descendants' do
    assert_equal TreeNode.find_by(path: 'Top.Science').descendants.pluck(:path), %w(
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

  test '.cascade_update' do
    node = TreeNode.find_by(path: 'Top.Hobbies')
    node.update path: 'Top.WoW'

    assert_equal node.self_and_descendants.pluck(:path), %w(
      Top.WoW
      Top.WoW.Amateurs_Astronomy
    )
  end

  test '.cascade_destroy' do
    TreeNode.find_by(path: 'Top.Collections').destroy

    assert_equal TreeNode.where("path ~ 'Top.Collections'").pluck(:path), %w()
  end
end
