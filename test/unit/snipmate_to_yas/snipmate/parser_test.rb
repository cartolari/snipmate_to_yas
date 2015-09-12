require 'test_helper'

module SnipmateToYas
  module Snipmate
    class ParserTest < Minitest::Test
      def test_it_parses_a_snippet_list_from_snipmate_to_yas
        snippets_text = <<-EOF.strip_heredoc
        snippet enc
          # encoding: utf-8
        snippet #!
          #!/usr/bin/env ruby
          # encoding: utf-8
        EOF
        expected_enc_snippet = <<-EOF.chomp.strip_heredoc
        # name: enc
        # key: enc
        # --
        # encoding: utf-8
        EOF
        expected_shebang_snippet = <<-EOF.chomp.strip_heredoc
        # name: #!
        # key: #!
        # --
        #!/usr/bin/env ruby
        # encoding: utf-8
        EOF

        snippets = Parser.new('ruby', snippets_text).parse

        should_be_enc_snippet = snippets.first
        assert_equal 'enc', should_be_enc_snippet.expand_key
        assert_equal expected_enc_snippet, should_be_enc_snippet.text

        should_be_shebang_snippet = snippets.last
        assert_equal '#!', should_be_shebang_snippet.expand_key
        assert_equal expected_shebang_snippet, should_be_shebang_snippet.text
      end

      def test_it_parses_a_snippet_list_with_comments_between_them
        snippets_text = <<-EOF.strip_heredoc
        # Some comment
        snippet enc
          # encoding: utf-8
        # Another comment
        snippet #!
          #!/usr/bin/env ruby
          # encoding: utf-8
        EOF
        expected_enc_snippet = <<-EOF.chomp.strip_heredoc
        # name: enc
        # key: enc
        # --
        # encoding: utf-8
        EOF
        expected_shebang_snippet = <<-EOF.chomp.strip_heredoc
        # name: #!
        # key: #!
        # --
        #!/usr/bin/env ruby
        # encoding: utf-8
        EOF

        snippets = Parser.new('ruby', snippets_text).parse

        should_be_enc_snippet = snippets.first
        assert_equal 'enc', should_be_enc_snippet.expand_key
        assert_equal expected_enc_snippet, should_be_enc_snippet.text

        should_be_shebang_snippet = snippets.last
        assert_equal '#!', should_be_shebang_snippet.expand_key
        assert_equal expected_shebang_snippet, should_be_shebang_snippet.text
      end

      def test_it_parses_snippets_with_comment_lines_preceding_snippets
        snippets_text = <<-EOF.strip_heredoc
        # General snippets

        snippet enc
          # encoding: utf-8
        snippet #!
          #!/usr/bin/env ruby
          # encoding: utf-8
        EOF
        expected_enc_snippet = <<-EOF.chomp.strip_heredoc
        # name: enc
        # key: enc
        # --
        # encoding: utf-8
        EOF
        expected_shebang_snippet = <<-EOF.chomp.strip_heredoc
        # name: #!
        # key: #!
        # --
        #!/usr/bin/env ruby
        # encoding: utf-8
        EOF

        snippets = Parser.new('ruby', snippets_text).parse

        should_be_enc_snippet = snippets.first
        assert_equal 'enc', should_be_enc_snippet.expand_key
        assert_equal expected_enc_snippet, should_be_enc_snippet.text

        should_be_shebang_snippet = snippets.last
        assert_equal '#!', should_be_shebang_snippet.expand_key
        assert_equal expected_shebang_snippet, should_be_shebang_snippet.text
      end

      def test_it_parses_snippets_with_empty_lines_in_snippet_definition
        snippets_text = <<-EOF.strip_heredoc
        # General snippets

        snippet enc
          # encoding: utf-8
        snippet #!
          #!/usr/bin/env ruby

          # encoding: utf-8
        EOF
        expected_enc_snippet = <<-EOF.chomp.strip_heredoc
        # name: enc
        # key: enc
        # --
        # encoding: utf-8
        EOF
        expected_shebang_snippet = <<-EOF.chomp.strip_heredoc
        # name: #!
        # key: #!
        # --
        #!/usr/bin/env ruby

        # encoding: utf-8
        EOF

        snippets = Parser.new('ruby', snippets_text).parse

        should_be_enc_snippet = snippets.first
        assert_equal 'enc', should_be_enc_snippet.expand_key
        assert_equal expected_enc_snippet, should_be_enc_snippet.text

        should_be_shebang_snippet = snippets.last
        assert_equal '#!', should_be_shebang_snippet.expand_key
        assert_equal expected_shebang_snippet, should_be_shebang_snippet.text
      end

      def test_it_splits_snippets_with_the_snippet_word_inside_the_definition
        snippets_text = <<-EOF.strip_heredoc
        snippet until
          until ${1:condition}
            ${0}
          end
        snippet cla class .. end
          class ${1:`substitute(vim_snippets#Filename(), '\(_\|^\)\(.\)', '\\u\\2', 'g')`}
            ${0}
          end
        EOF
        expected_until_snippet = <<-EOF.chomp.strip_heredoc
        # name: until
        # key: until
        # --
        until ${1:condition}
          $0
        end
        EOF
        expected_class_snippet = <<-EOF.chomp.strip_heredoc
        # name: class .. end
        # key: cla
        # --
        class ${1:}
          $0
        end
        EOF

        snippets = Parser.new('ruby', snippets_text).parse

        should_be_until_snippet = snippets.first
        assert_equal 'until', should_be_until_snippet.expand_key
        assert_equal expected_until_snippet, should_be_until_snippet.text

        should_be_class_snippet = snippets.last
        assert_equal 'cla', should_be_class_snippet.expand_key
        assert_equal expected_class_snippet, should_be_class_snippet.text
      end

      def test_it_handles_snippet_text_with_parent_mode
        snippets_text = <<-EOF.strip_heredoc
        extends c

        snippet cout
          std::cout << ${1} << std::endl;
        EOF
        expected_enc_snippet = <<-EOF.chomp.strip_heredoc
        # name: cout
        # key: cout
        # --
        std::cout << $1 << std::endl;
        EOF

        snippets = Parser.new('ruby', snippets_text).parse

        should_be_enc_snippet = snippets.first
        assert_equal 1, snippets.count
        assert_equal 'cout', should_be_enc_snippet.expand_key
        assert_equal expected_enc_snippet, should_be_enc_snippet.text
      end

      def test_it_creates_a_mode_from_the_mode_name
        snippets_text = <<-EOF.strip_heredoc
        snippet a
          a
        EOF
        parser = Parser.new('ruby', snippets_text)

        collection = parser.parse

        assert_instance_of Mode, collection.mode
      end

      def test_it_creates_a_mode_with_the_appropriate_parent
        snippets_text = <<-EOF.strip_heredoc
        extends c
        snippet cout
          std::cout << ${1} << std::endl;
        EOF

        parser = Parser.new('cpp', snippets_text)
        collection = parser.parse
        mode_name = collection.mode.parent.emacs_name

        assert_equal 'c', mode_name
      end
    end
  end
end
