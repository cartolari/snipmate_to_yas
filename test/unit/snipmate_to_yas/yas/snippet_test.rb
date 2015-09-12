require 'test_helper'

module SnipmateToYas
  module Yas
    class SnippetTest < MiniTest::Test
      def test_it_initializes_itself_with_the_righ_attributes
        snippet = Snippet.new(expand_key: 'key', text: 'snippet content')

        assert_equal 'key', snippet.expand_key
        assert_equal 'snippet content', snippet.text
      end
    end
  end
end
