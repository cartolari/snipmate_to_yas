require 'fileutils'

module SnipmateToYas
  ## Cli wrapper for snipmate to yas
  class Cli
    def initialize(args, out = STDOUT)
      @args = args
      @out = out
    end

    def run
      if @args.length != 2 || @args.join('').strip == '--help'
        @out.puts 'USAGE: snipmate_to_yas snipmate.snippets target_yas_dir'
        return
      end
      generate_snippets
    end

    protected

    def generate_snippets
      mode_name = File.basename(@args.first, '.*')
      snippets = Snipmate::Parser.new(mode_name, open(@args.first).read).parse
      SnippetFsWriter.new(snippets, @args.last).write
    end
  end
end
