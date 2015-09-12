module SnipmateToYas
  module Yas
    ## A single YASnippet snippet
    class Snippet
      attr_accessor :expand_key, :text

      def initialize(attrs = {})
        attrs.each do |key, value|
          send("#{key}=", value)
        end
      end
    end
  end
end
