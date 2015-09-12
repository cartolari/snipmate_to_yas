require 'test_helper'
require 'minitest/mock'
require 'fakefs/safe'

module SnipmateToYas
  class CliTest < Minitest::Test
    def test_it_correctly_collaborates_with_snipmate_to_yas
      FakeFS do
        snipmate_dir = '/tmp/snipmate/'
        snipmate_snippets_file = '/tmp/snipmate/ruby.snippets'
        yas_dir = '/tmp/yas'
        mode_dir = "#{yas_dir}/ruby-mode"
        snippets = <<EOF
snippet enc
  # encoding: utf-8
snippet #!
  #!/usr/bin/env ruby
  # encoding: utf-8
EOF
        FileUtils.mkdir_p(snipmate_dir)
        FileUtils.mkdir_p(yas_dir)
        File.open(snipmate_snippets_file, 'w') { |f| f << snippets }
        args = [snipmate_snippets_file, yas_dir]
        cli = Cli.new(args)

        cli.run
        generated_snippets =
          Dir["#{mode_dir}/*"].map { |f| Pathname.new(f).basename.to_s }

        assert_equal %w(enc #!).sort, generated_snippets.sort
        assert_equal open("#{mode_dir}/enc").read, <<EOF.chomp
# name: enc
# key: enc
# --
# encoding: utf-8
EOF
        assert_equal open("#{mode_dir}/#!").read, <<EOF.chomp
# name: #!
# key: #!
# --
#!/usr/bin/env ruby
# encoding: utf-8
EOF
      end
    end

    class OutStub
      attr_accessor :output

      def initialize
        @output = ''
      end

      def puts(args)
        @output << args
      end
    end

    def test_it_displays_help
      out = OutStub.new
      cli = Cli.new(['--help'], out)

      cli.run

      assert_match(/^USAGE.*/, out.output)
    end

    def test_it_displays_help_with_invalid_args
      out = OutStub.new
      cli = Cli.new([], out)

      cli.run

      assert_match(/^USAGE.*/, out.output)
    end
  end
end
