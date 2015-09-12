require 'test_helper'

module SnipmateToYas
  module Snipmate
    class SingleParserTest < Minitest::Test
      def test_it_converts_a_snipmate_snippet_to_yas
        snipmate_snippet = <<EOF
snippet def
  def ${1:method_name}
    $0
  end
EOF
        expected_yas_snippet = <<EOF.chomp
# name: def
# key: def
# --
def ${1:method_name}
  $0
end
EOF
        converter = SingleParser.new(snipmate_snippet)

        yas_snippet = converter.convert

        assert_equal expected_yas_snippet, yas_snippet.text
        assert_equal 'def', yas_snippet.expand_key
      end

      def test_it_raises_error_in_invalid_snippet_format
        snipmate_snippet = <<EOF
ea
  each { |${1:e}| ${0} }
EOF
        converter = SingleParser.new(snipmate_snippet)

        assert_raises ArgumentError do
          converter.convert
        end
      end

      def test_it_raises_error_if_snippet_has_only_one_line
        snipmate_snippet = 'snippet ea'
        converter = SingleParser.new(snipmate_snippet)

        assert_raises ArgumentError do
          converter.convert
        end
      end

      def test_it_removes_trailing_whitespaces_from_snippet_name
        snipmate_snippet = <<EOF.chomp
snippet      ea
  each { |${1:e}| ${0} }
EOF
        yas_snippet = SingleParser.new(snipmate_snippet).convert

        assert_equal 'ea', yas_snippet.expand_key
      end

      def test_it_handles_snippets_with_hard_tabs
        tab = "\u0009"
        snipmate_snippet = <<EOF
snippet ea
#{tab}each { |${1:e}| ${0} }
EOF
        expected_yas_snippet = <<EOF.chomp
# name: ea
# key: ea
# --
each { |${1:e}| $0 }
EOF
        yas_snippet = SingleParser.new(snipmate_snippet).convert

        assert_equal expected_yas_snippet, yas_snippet.text
        assert_equal 'ea', yas_snippet.expand_key
      end

      def test_it_convets_snippet_interpolation
        snipmate_snippet = <<EOF
snippet ea
  each { |${1:`some interpolation`}| ${0} }
EOF
        expected_yas_snippet = <<EOF.chomp
# name: ea
# key: ea
# --
each { |${1:`yas interpolation`}| $0 }
EOF
        interpolation_converter =
          Class.new { define_method(:convert) { |_| 'yas interpolation' } }.new
        converter = SingleParser.new(snipmate_snippet, interpolation_converter)

        yas_snippet = converter.convert

        assert_equal expected_yas_snippet, yas_snippet.text
        assert_equal 'ea', yas_snippet.expand_key
      end

      def test_it_handles_snippets_with_description
        snipmate_snippet = <<EOF
snippet cla class .. end
  class ${1}
    ${0}
  end
EOF
        expected_yas_snippet = <<EOF.chomp
# name: class .. end
# key: cla
# --
class $1
  $0
end
EOF
        converter = SingleParser.new(snipmate_snippet)

        yas_snippet = converter.convert

        assert_equal expected_yas_snippet, yas_snippet.text
        assert_equal 'cla', yas_snippet.expand_key
      end

      def test_it_handles_non_word_chars_in_snippet_name
        snipmate_snippet = <<EOF
snippet cla<
  class ${1} < ${2}
  end
EOF
        expected_yas_snippet = <<EOF.chomp
# name: cla<
# key: cla<
# --
class $1 < $2
end
EOF
        converter = SingleParser.new(snipmate_snippet)

        yas_snippet = converter.convert

        assert_equal expected_yas_snippet, yas_snippet.text
        assert_equal 'cla<', yas_snippet.expand_key
      end

      def test_it_correctly_generates_snippet_exit_point
        snipmate_snippet = <<EOF
snippet ea
  each { |${1:e}| ${0} }
EOF
        expected_yas_snippet = <<EOF.chomp
# name: ea
# key: ea
# --
each { |${1:e}| $0 }
EOF
        converter = SingleParser.new(snipmate_snippet)

        yas_snippet = converter.convert

        assert_equal expected_yas_snippet, yas_snippet.text
        assert_equal 'ea', yas_snippet.expand_key
      end

      def test_it_parses_a_snippet_without_indentation
        snipmate_snippet = <<EOF
snippet ea
each { |${1:e}| ${0} }
EOF
        expected_yas_snippet = <<EOF.chomp
# name: ea
# key: ea
# --
each { |${1:e}| $0 }
EOF
        converter = SingleParser.new(snipmate_snippet)

        yas_snippet = converter.convert

        assert_equal expected_yas_snippet, yas_snippet.text
        assert_equal 'ea', yas_snippet.expand_key
      end

      def test_it_converts_interpolations_of_non_tab_stops
        snipmate_snippet = <<EOF
snippet ea
  call(`some interpolation`)
EOF
        expected_yas_snippet = <<EOF.chomp
# name: ea
# key: ea
# --
call(`yas interpolation`)
EOF
        interpolation_converter =
          Class.new { define_method(:convert) { |_| 'yas interpolation' } }.new
        converter = SingleParser.new(snipmate_snippet, interpolation_converter)

        yas_snippet = converter.convert

        assert_equal expected_yas_snippet, yas_snippet.text
        assert_equal 'ea', yas_snippet.expand_key
      end

      def test_it_calls_interpolation_converter_without_backticks
        snipmate_snippet = <<EOF
snippet ea
  call(`some interpolation`)
EOF
        interpolation_converter = Class.new do
          attr_reader :last_convert_argument

          define_method(:convert) do |snippet|
            @last_convert_argument = snippet
          end
        end.new
        converter = SingleParser.new(snipmate_snippet, interpolation_converter)

        converter.convert

        assert_equal 'some interpolation',
                     interpolation_converter.last_convert_argument
      end

      def test_it_convets_snippet_with_two_interpolations_inline
        snipmate_snippet = <<EOF
snippet ea
  each { |${1:`some interpolation`}| ${0:`another interpolation`} }
EOF
        expected_yas_snippet = <<EOF.chomp
# name: ea
# key: ea
# --
each { |${1:`yas interpolation`}| ${0:`yas interpolation`} }
EOF
        interpolation_converter =
          Class.new { define_method(:convert) { |_| 'yas interpolation' } }.new
        converter = SingleParser.new(snipmate_snippet, interpolation_converter)

        yas_snippet = converter.convert

        assert_equal expected_yas_snippet, yas_snippet.text
        assert_equal 'ea', yas_snippet.expand_key
      end
    end
  end
end
