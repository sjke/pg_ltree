require 'test_helper'

class PgLtree::ScopedForTest < ActiveSupport::TestCase

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
        %i( active deactive ).each do |status|
          NotUniqTreeNode.create! new_path: path, status: status
        end
      end
    end

    def teardown
      NotUniqTreeNode.delete_all
    end

    test '#roots' do
      assert_equal NotUniqTreeNode.roots.pluck(:new_path), ['Top', 'Top']
    end

    test '#at_depth' do
      assert_equal NotUniqTreeNode.at_depth(5).pluck(:new_path), %w(
        Top.Collections.Pictures.Astronomy.Stars
        Top.Collections.Pictures.Astronomy.Stars
        Top.Collections.Pictures.Astronomy.Galaxies
        Top.Collections.Pictures.Astronomy.Galaxies
        Top.Collections.Pictures.Astronomy.Astronauts
        Top.Collections.Pictures.Astronomy.Astronauts
      )
    end

    test '#leaves' do
      assert_equal NotUniqTreeNode.where(status: :active).leaves.pluck(:new_path), %w(
        Top.Science.Astronomy.Astrophysics
        Top.Science.Astronomy.Cosmology
        Top.Hobbies.Amateurs_Astronomy
        Top.Collections.Pictures.Astronomy.Stars
        Top.Collections.Pictures.Astronomy.Galaxies
        Top.Collections.Pictures.Astronomy.Astronauts
      )
    end

    test '#where_path_liked' do
      assert_equal NotUniqTreeNode.where_path_liked('*{2}.Astronomy|Pictures').pluck(:new_path), %w(
        Top.Science.Astronomy
        Top.Science.Astronomy
        Top.Collections.Pictures
        Top.Collections.Pictures
      )
    end

    def not_uniq_tree_node_find_by_path(path)
      NotUniqTreeNode.find_by(status: :active, new_path: path)
    end

    test '.root?' do
      assert not_uniq_tree_node_find_by_path('Top').root?
      assert_not not_uniq_tree_node_find_by_path('Top.Science').root?
    end

    test '.depth' do
      assert_equal not_uniq_tree_node_find_by_path('Top.Hobbies.Amateurs_Astronomy').depth, 3
    end

    test '.root' do
      assert_equal not_uniq_tree_node_find_by_path('Top.Hobbies.Amateurs_Astronomy').root.new_path, 'Top'
    end

    test '.parent' do
      assert_equal not_uniq_tree_node_find_by_path('Top.Collections.Pictures.Astronomy.Astronauts').parent.new_path,
        'Top.Collections.Pictures.Astronomy'
    end

    test '.leaves' do
      assert_equal not_uniq_tree_node_find_by_path('Top.Science').leaves.pluck(:new_path), %w(
        Top.Science.Astronomy.Astrophysics
        Top.Science.Astronomy.Cosmology
      )
    end

    test '.leaf?' do
      assert_not not_uniq_tree_node_find_by_path('Top').leaf?
      assert not_uniq_tree_node_find_by_path('Top.Collections.Pictures.Astronomy.Astronauts').leaf?
    end

    test '.self_and_ancestors' do
      assert_equal not_uniq_tree_node_find_by_path('Top.Collections.Pictures.Astronomy.Astronauts').self_and_ancestors.pluck(:new_path), %w(
        Top
        Top.Collections
        Top.Collections.Pictures
        Top.Collections.Pictures.Astronomy
        Top.Collections.Pictures.Astronomy.Astronauts
      )
    end

    test '.ancestors' do
      assert_equal not_uniq_tree_node_find_by_path('Top.Collections.Pictures.Astronomy.Astronauts').ancestors.pluck(:new_path), %w(
        Top
        Top.Collections
        Top.Collections.Pictures
        Top.Collections.Pictures.Astronomy
      )
    end

    test '.self_and_descendents' do
      assert_equal not_uniq_tree_node_find_by_path('Top.Science').self_and_descendents.pluck(:new_path), %w(
        Top.Science
        Top.Science.Astronomy
        Top.Science.Astronomy.Astrophysics
        Top.Science.Astronomy.Cosmology
      )
    end

    test '.descendents' do
      assert_equal not_uniq_tree_node_find_by_path('Top.Science').descendents.pluck(:new_path), %w(
        Top.Science.Astronomy
        Top.Science.Astronomy.Astrophysics
        Top.Science.Astronomy.Cosmology
      )
    end

    test '.self_and_siblings' do
      assert_equal not_uniq_tree_node_find_by_path('Top.Collections.Pictures.Astronomy.Stars').self_and_siblings.pluck(:new_path), %w(
        Top.Collections.Pictures.Astronomy.Stars
        Top.Collections.Pictures.Astronomy.Galaxies
        Top.Collections.Pictures.Astronomy.Astronauts
      )
    end


    test '.siblings' do
      assert_equal not_uniq_tree_node_find_by_path('Top.Collections.Pictures.Astronomy.Stars').siblings.pluck(:new_path), %w(
        Top.Collections.Pictures.Astronomy.Galaxies
        Top.Collections.Pictures.Astronomy.Astronauts
      )
    end

    test '.children' do
      assert_equal not_uniq_tree_node_find_by_path('Top.Hobbies').children.pluck(:new_path), %w(
        Top.Hobbies.Amateurs_Astronomy
      )
    end
end
