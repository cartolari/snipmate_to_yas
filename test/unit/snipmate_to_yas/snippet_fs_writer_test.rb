require 'test_helper'
require 'fakefs/safe'

module SnipmateToYas
  class SnippetFsWriterTest < MiniTest::Test
    def teardown
      FakeFS::FileSystem.clear
    end

    def test_writes_one_snippet_to_the_specified_file
      FakeFS do
        dir = '/tmp/snippets'
        mode_dir = "#{dir}/ruby-mode"
        FileUtils.mkdir_p(dir)
        snippets = Snipmate::Collection.new(
          Mode.from_vim('ruby'),
          [Yas::Snippet.new(text: 'SNIPPET 1', expand_key: 'class')]
        )

        snippet_writer = SnippetFsWriter.new(snippets, dir)

        snippet_writer.write
        found_snippets = Dir["#{mode_dir}/*"].map do |f|
          Pathname.new(f).basename.to_s
        end

        assert_equal %w(class), found_snippets
        assert_equal 'SNIPPET 1', open(File.join(mode_dir, 'class')).read
      end
    end

    def test_writes_multiple_snippets_to_the_specified_file
      FakeFS do
        dir = '/tmp/snippets'
        mode_dir = "#{dir}/ruby-mode"
        FileUtils.mkdir_p(dir)
        snippets = Snipmate::Collection.new(
          Mode.from_vim('ruby'),
          [Yas::Snippet.new(text: 'SNIPPET 1', expand_key: 'sn1'),
           Yas::Snippet.new(text: 'SNIPPET 2', expand_key: 'sn2')]
        )
        snippet_writer = SnippetFsWriter.new(snippets, dir)

        snippet_writer.write
        found_snippets = Dir["#{mode_dir}/*"].map do |f|
          Pathname.new(f).basename.to_s
        end

        assert_equal %w(sn1 sn2), found_snippets
      end
    end

    def test_cleans_up_filename_before_writing
      FakeFS do
        dir = '/tmp/snippets'
        mode_dir = "#{dir}/ruby-mode"
        FileUtils.mkdir_p(dir)

        snippets = Snipmate::Collection.new(
          Mode.from_vim('ruby'),
          [Yas::Snippet.new(text: 'SNIPPET 1', expand_key: '#!snip_/\<>"?*.ext')]
        )
        snippet_writer = SnippetFsWriter.new(snippets, dir)

        snippet_writer.write
        found_snippets = Dir["#{mode_dir}/*"].map do |f|
          Pathname.new(f).basename.to_s
        end

        assert_equal '#!snip________.ext', found_snippets.first
      end
    end

    def test_it_handles_dot_only_snippet_name
      FakeFS do
        dir = '/tmp/snippets'
        mode_dir = "#{dir}/ruby-mode"
        FileUtils.mkdir_p(dir)

        snippets = Snipmate::Collection.new(
          Mode.new('ruby'),
          [Yas::Snippet.new(text: 'SNIPPET 1', expand_key: '.')]
        )
        snippet_writer = SnippetFsWriter.new(snippets, dir)

        snippet_writer.write
        found_snippets = Dir["#{mode_dir}/*"].map do |f|
          Pathname.new(f).basename.to_s
        end

        assert_equal '_', found_snippets.first
      end
    end

    def test_generates_the_right_parent_mode
      FakeFS do
        dir = '/tmp/snippets'
        FileUtils.mkdir_p(dir)
        mode = Mode.from_emacs('go')
        mode.parent = Mode.from_emacs('c')
        snippets = Snipmate::Collection.new(
          mode, [Yas::Snippet.new(text: 'SNIPPET 1', expand_key: '.')]
        )
        snippet_writer = SnippetFsWriter.new(snippets, dir)

        snippet_writer.write
        yas_parents = File.read('/tmp/snippets/go-mode/.yas-parents')

        assert_equal 'c-mode', yas_parents
      end
    end

    def test_generates_symbolic_links_to_mode_aliases
      FakeFS do
        dir = '/tmp/snippets'
        FileUtils.mkdir_p(dir)
        mode = Mode.from_emacs('ruby')
        snippets = Snipmate::Collection.new(
          mode, [Yas::Snippet.new(text: 'SNIPPET 1', expand_key: '.')]
        )
        snippet_writer = SnippetFsWriter.new(snippets, dir)

        snippet_writer.write
        enh_ruby_alias_dir = File.readlink('/tmp/snippets/enh-ruby-mode')

        assert_equal 'ruby-mode', enh_ruby_alias_dir
      end
    end
  end
end
