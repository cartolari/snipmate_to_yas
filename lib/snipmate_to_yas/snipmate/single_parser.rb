require 'erb'
require 'snipmate_to_yas/snipmate/default_interpolation_converter'

module SnipmateToYas
  module Snipmate
    ## Parses a single vim snipmate snippet
    class SingleParser
      EMPTY_PLACEHOLDER_REGEXP = /\$\{(?<index>\d+)\}/
      HEADING_LINE = /^snippet\s+(?<key>[^\s]+)\s+(?<name>.*)$/
      INTERPOLATION_REGEXP = /`(?<interpolation>([^`]+))`|(?<interpolation>\$\{VISUAL\})/
      SNIPPET = <<-EOF.strip_heredoc.chomp
      # name: <%= name %>
      # key: <%= key %>
      # --
      <%= body %>
      EOF
      TEMPLATE = ERB.new(SNIPPET)

      def initialize(snipmate_snippet, interpolation_converter = nil)
        fail(ArgumentError, 'snippet must not be nil') if snipmate_snippet.nil?

        @snipmate_snippet = snipmate_snippet
        @interpolation_converter =
          interpolation_converter || DefaultInterpolationConverter.new
      end

      def convert
        validate_snippet
        Yas::Snippet.new(text: TEMPLATE.result(binding), expand_key: key)
      end

      protected

      def validate_snippet
        fail(
          ArgumentError,
          "Snippet '#{@snipmate_snippet}' is not in recognizable format"
        ) unless @snipmate_snippet.match(HEADING_LINE)

        fail(
          ArgumentError, "Snippet '#{@snipmate_snippet}' must contain a body"
        ) if body.empty?
      end

      def name
        return heading_tokens[:name] unless heading_tokens[:name].empty?
        heading_tokens[:key]
      end

      def key
        heading_tokens[:key]
      end

      def heading_tokens
        @snipmate_snippet.lines.first.match(HEADING_LINE)
      end

      def body
        remove_braces_from_empty_placeholders(
          convert_interpolations(raw_body)
        ).chomp
      end

      def remove_braces_from_empty_placeholders(snippet)
        snippet.gsub(EMPTY_PLACEHOLDER_REGEXP) do
          "$#{Regexp.last_match[:index]}"
        end
      end

      def convert_interpolations(snippet)
        snippet.gsub(INTERPOLATION_REGEXP) do
          interpolation =
            @interpolation_converter.convert(Regexp.last_match[:interpolation])

          interpolation.nil? ? '' : "`#{interpolation}`"
        end
      end

      def raw_body
        @snipmate_snippet.lines.drop(1).map do |line|
          line.gsub(/^#{detect_indentation}/, '')
        end.join('')
      end

      def detect_indentation
        match = @snipmate_snippet.lines[1].match(/^(?<indentation>\s+).*$/)
        return match[:indentation] if match
        ''
      end
    end
  end
end
