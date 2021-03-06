require 'test_helper'

module SnipmateToYas
  class ModeTest < MiniTest::Test
    def test_it_builds_a_mode_from_a_vim_mode_name
      mode = Mode.from_vim('cpp')

      assert_equal 'cpp', mode.vim_name
    end

    def test_it_builds_a_mode_from_an_emacs_mode_name
      mode = Mode.from_emacs('c++')

      assert_equal 'c++', mode.emacs_name
    end

    def test_vim_mode_knows_its_emacs_mode_name
      mode = Mode.from_vim('cpp').emacs_name

      assert_equal 'c++', mode
    end

    def test_emacs_mode_knows_its_vim_mode_name
      mode = Mode.from_emacs('c++').vim_name

      assert_equal 'cpp', mode
    end

    def test_undescore_mode_has_no_parent
      mode = Mode.from_vim('_')
      assert_nil mode.parent
    end

    def test_every_mode_but_underscore_have_a_parent
      mode_names = Mode::VIM_TO_EMACS_MODE_MAP.keys.reject { |k| k == '_' }

      all_modes_have_parent = mode_names.all? do |name|
        !Mode.from_vim(name).parent.nil?
      end

      assert all_modes_have_parent, 'All modes have parents'
    end

    def test_it_initializes_with_the_right_parent
      cpp_mode = Mode.from_vim('cpp')

      cpp_mode.parent = Mode.from_vim('c')

      assert_equal Mode.from_vim('c').vim_name, cpp_mode.parent.vim_name
    end

    def test_unknown_modes_have_the_same_name_in_vim_and_emacs
      unknown_mode = Mode.from_vim('unknown')

      emacs_mode = unknown_mode.emacs_name

      assert_equal emacs_mode, 'unknown'
    end

    def test_ruby_mdoe_have_an_alias
      ruby_mode = Mode.from_vim('ruby')

      aliases = ruby_mode.aliases

      assert_equal ['enh-ruby'], aliases
    end

    def test_modes_without_aliases_have_empty_aliases
      unknown_mode = Mode.from_vim('unknown')

      aliases = unknown_mode.aliases

      assert_equal [], aliases
    end
  end
end
