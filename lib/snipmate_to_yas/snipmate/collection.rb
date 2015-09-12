module SnipmateToYas
  module Snipmate
    ## A list of snipmate snippets, generally contained in a file
    class Collection
      include Enumerable

      attr_reader :mode

      def initialize(mode, snippets = [])
        @mode = mode
        @snippets = snippets
      end

      def each(&block)
        @snippets.each(&block)
      end

      def last
        @snippets.last
      end
    end
  end
end
