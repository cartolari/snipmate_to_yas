require_relative 'snipmate_to_yas'
require 'minitest/autorun'

## Snipmate to Yas test
# rubocop:disable Metrics/MethodLength
class SnipmateToYasTest < Minitest::Test
  def setup
  end

  def test_it_converts_a_snipmate_snippet_to_yas
    snipmate_snippet = <<EOF
snippet def
  def ${1:method_name}
    ${0}
  end
EOF
    expected_yas_snippet = <<EOF
# name: def
# key: def
# --
def ${1:method_name}
  ${0}
end
EOF
    converter = SnipmateToYas.new(snipmate_snippet)

    yas_snippet = converter.convert

    assert_equal expected_yas_snippet, yas_snippet.text
    assert_equal 'def', yas_snippet.expand_key
  end

  def test_another_simple_snippet_case
    snipmate_snippet = <<EOF
snippet ea
  each { |${1:e}| ${0} }
EOF
    expected_yas_snippet = <<EOF
# name: ea
# key: ea
# --
each { |${1:e}| ${0} }
EOF
    converter = SnipmateToYas.new(snipmate_snippet)

    yas_snippet = converter.convert

    assert_equal expected_yas_snippet, yas_snippet.text
    assert_equal 'def', yas_snippet.expand_key
  end

  def test_it_raises_error_in_invalid_snippet_format
    snipmate_snippet = <<EOF
ea
  each { |${1:e}| ${0} }
EOF
    converter = SnipmateToYas.new(snipmate_snippet)

    assert_raises ArgumentError do
      converter.convert
    end
  end

  def test_it_raises_error_if_snippet_has_only_one_line
    snipmate_snippet = 'snippet ea'
    converter = SnipmateToYas.new(snipmate_snippet)

    assert_raises ArgumentError do
      converter.convert
    end
  end
end
