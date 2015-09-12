module SnipmateToYas
  module Snipmate
    ## Converts a string with multiple Snipmate snippets to an array of
    # YASSnippets.
    # This string generally is the content of a Snipmate snippets file.
    class Parser
      PARENT_MODE_REGEXP = /^extends (?<mode>\w+)$/

      def initialize(mode_name, snippets_text)
        @mode_name = mode_name
        @snippets_text = snippets_text
      end

      def parse
        Snipmate::Collection.new(parse_mode, snippets)
      end

      protected

      def parse_mode
        Mode.from_vim(@mode_name).tap do |mode|
          mode.parent = Mode.from_vim(parent_mode) if parent_mode
        end
      end

      def parent_mode
        parent_mode = @snippets_text.lines.find do |snippet|
          snippet.match(PARENT_MODE_REGEXP)
        end
        return unless parent_mode
        parent_mode.match(PARENT_MODE_REGEXP)[:mode]
      end

      def snippets
        snippet_list.split(/^snippet/).map do |snip|
          next nil if snip.strip.empty?
          parse_snippet "snippet #{snip}"
        end.compact
      end

      def snippet_list
        @snippets_text.lines.reject do |snippet|
          snippet.match(/^#.*$/) || snippet.match(PARENT_MODE_REGEXP)
        end.join('')
      end

      def parse_snippet(snippet)
        Snipmate::SingleParser.new(snippet).convert
      end
    end
  end
end
