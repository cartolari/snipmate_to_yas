require 'ostruct'

## Converts a vim snipmate snippet to Emacs YASnippet format
class SnipmateToYas
  def initialize(snipmate_snippet)
    @snipmate_snippet = snipmate_snippet
  end

  def convert
    validate_snippet
    snippet = <<-EOF
# name: #{snippet_key}
# key: #{snippet_key}
# --
#{snippet_body}
EOF
    OpenStruct.new(text: snippet, expand_key: 'def')
  end

  protected

  def validate_snippet
    fail ArgumentError, 'Snippet must not be nil' if
      @snipmate_snippet.nil?
    fail ArgumentError, 'Snippet must contain a body' if
      @snipmate_snippet.lines.size == 1
    fail ArgumentError, 'Snippet is not in recognizable format' unless
      @snipmate_snippet.match(/^snippet .*$/)
  end

  def snippet_key
    @snipmate_snippet.lines.first.match(/^snippet (.*)$/)[1]
  end

  def snippet_body
    @snipmate_snippet.lines.drop(1).map do |line|
      line.gsub(/^  /, '')
    end.join('').chomp
  end
end
